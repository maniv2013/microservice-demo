/**
 * Copyright (C) 2021 jklm, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALING
 * IN THE SOFTWARE.
 */

package com.jklm.microservices.user.config;

import org.springframework.data.couchbase.repository.Collection;
import org.springframework.data.couchbase.repository.CouchbaseRepository;
import org.springframework.data.couchbase.repository.DynamicProxyable;
import org.springframework.data.couchbase.repository.ScanConsistency;
import org.springframework.stereotype.Repository;

import com.couchbase.client.java.query.QueryScanConsistency;

/**
 * Booking repository<br>
 * The DynamicProxyable interface exposes bookingRepository.withScope(scope), withCollection() and withOptions() It's
 * necessary on the repository object itself because the withScope() etc methods need to return an object of type
 * BookingRepository so that one can code... bookingRepository = bookingRepository.withScope(scopeName) without having
 * to cast the result.
 *
 * @author Michael Reiche
 */
@Repository("bookingRepository")
@Collection("bookings")
@ScanConsistency(query = QueryScanConsistency.REQUEST_PLUS)
public interface BookingRepository extends CouchbaseRepository<Booking, String>, DynamicProxyable<BookingRepository> {

}
