//
//  DVGStream+MapKit.m
//  NineHundredSeconds
//
//  Created by Nikolay Morev on 11.11.14.
//  Copyright (c) 2014 DENIVIP Group. All rights reserved.
//

#import "MapKit+Additions.h"
@implementation MKMapView (DvAdditions)

-(void)zoomToFitMapAnnotations
{
    MKMapView* mapView = self;
    //    // we have whole world usially
    //    //MKCoordinateRegion region = MKCoordinateRegionForMapRect(MKMapRectWorld);
    //    //[self.mapView setRegion:region animated:NO];
    //    // methods cant cross date line -> center is invalid!!!
    //    MKMapRect combinedRect = DVGMKAnnotationsBoundingMapRect(self.viewers);
    //    MKMapRect focusRect = [self.mapView mapRectThatFits:combinedRect];
    //    [self.mapView setVisibleMapRect:focusRect
    //                        edgePadding:UIEdgeInsetsMake(kClusterAutoZoomingRad, kClusterAutoZoomingRad, kClusterAutoZoomingRad, kClusterAutoZoomingRad)
    //                           animated:NO];
    
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    // minimum zoom level - country
    if(region.span.latitudeDelta < 15.0){
        region.span.latitudeDelta = 15.0;
    }
    if(region.span.longitudeDelta < 15.0){
        region.span.longitudeDelta = 15.0;
    }
    //NSLog(@"region span %f %f", region.span.latitudeDelta, region.span.longitudeDelta);
    region = [mapView regionThatFits:region];
    //.camera.altitude *= 1.4;
    [mapView setRegion:region animated:YES];
}

@end