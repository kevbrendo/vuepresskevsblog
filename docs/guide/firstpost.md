# Data Layer

Writing this article is dangerous. Data Layer is two marketers short of becoming a buzz word. This occasion will be heralded by articles such as “Data Layer Is Dead”, “This Developer Implemented A Data Layer And You'll Never Guess What Happened Next”, and other examples of the kind of content generation whose propagation should be prevented by military force. This is not one of those articles, I hope, but rather an honest look at what Data Layer is from a number of perspectives.

And there are many perspectives, indeed. The terminology itself is difficult to pin down. In this article, I will consider Data Layer to comprise the following definitions:

The description of business requirements and goals, aligned in a format that is readily transferrable to technical specifications

The concept of a discrete layer of semantic information, stored in a digital context

I will also use the variable name dataLayer to denote the data structure used by Google Tag Manager for storing, processing, and passing data between the digital context and the tag management solution. I also prefer the term digital context to website, for example, since the Data Layer can be used in a variety of context, not just a public-facing web environment.

The Data Layer most explored in this article is the one that is firmly rooted in the DMZ between developers and marketers. It's very much a technical concept, since its existence is justified by the limitations imposed by certain web technologies (JavaScript, for example) upon how browsers interact with applications (Google Tag Manager, for example). At the same time, Data Layer is, and ought to be, owned at least partly by marketers, analysts, executives, designers, and communication professionals, who draft the business requirements and goals that are satisfied by data collection methods.

In other words, it's very common that the governance of Data Layer is debated hotly among different stakeholders of the “data organization” within a company. Since, as we will learn, it's a generic data model that can be used by all applications that interface with your digital data, it's very difficult to draft a governance model that would satisfy all parties. This, too, we'll explore in this post.

In the end I'll share some great resources for learning more about Data Layer, since this post will not be a deep-dive (even though it is wordy).

## What Is The Data Layer

To put it shortly, a Data Layer is a data structure which ideally holds all data that you want to process and pass from your website (or other digital context) to other applications that you have linked to.

The reason we use a Data Layer is because sometimes it is necessary to decouple semantic information from other information stored in the digital context. This, in turn, is because if we reuse information already available, there's a risk that once modifications are done to the original source, the integrity of the data will be compromised.

A very common example is web analytics tracking. You might have a Data Layer which feeds data into your analytics tool about the visitor. Often, this data isn't available in the presentational layer, or in the markup at all. This data might be, for example, details about the visitor (login status, user ID, geolocation), metadata about the page (optimal resolution, image copyrights), or even information that's already in the markup, but that you want to access in a more robust way.

This duplication is often seen in eCommerce data. Instead of “scraping” transactional details from the header or content of the page, it's more reliable to use the Data Layer to carry this information, since only this way is the data uncoupled from the website proper, meaning it is less subject to errors when markup is modified.

If, for example, you were inclined to use data stored in a H2 heading of the HTML markup in the thank you page, a single change to the markup or the format of the information in this HTML element would compromise data collection from the site to your tracking tool. If, however, the data were stored in a Data Layer with no link to the presentational layer, there is a far smaller risk of unexpected changes occurring (though it's definitely not impossible).

So, in short, the Data Layer is a data structure for storing, processing, and passing information about the context it exists in.

## The Data Layer: The Non-Technical Perspective

For the marketer, the analyst, the executive, the communications officer, or other non-developer, the Data Layer is actually a list of business requirements and goals for each subset of the digital context.

For a web store, for example, business requirements and goals might include transactional information (what was purchased), user data (who made the purchase), spatial and temporal details (where was the purchase made in and at what time), and information about possible micro conversions (did the user subscribe to product updates).

For another part of the same website, the business requirements and goals might include simply details about which social media channel brought the user to the website, or which pages the user has viewed more than once.

These are not technical specifications, but clearly defined lists of items that need to be collected in order to satisfy the business goals set for each business area of the website or other digital context.

Ideally, the Data Layer carries information which can be used by as many different tools / users / stakeholders as possible, but it's very common that idiosyncrasies emerge. This is why it's extremely important to treat the Data Layer as a living, agile model, not a stagnated, monolithic, singular entity.

Similarly to any aspect of digital analytics, a Data Layer should also be treated as something that's constantly in flux. The data it holds must be optimized, elaborated, divided, conjoined, cleaned, refactored, and questioned as often as new business requirements emerge, or when previous goals were not beneficial to the business.

## Google Tag Manager's dataLayer

Since there's no existing standard for the data model explored in this article (the effort is under way, though), the Data Layer can have many technical guises. The technical perspective I've chosen is the one that has evolved through Google Tag Manager. This is because I think, and I'm only slightly biased here, that dataLayer is one of the more elegant implementations of a structured data model in the web environment.

dataLayer is a JavaScript Array, which holds data in key-value pairs. The key is a variable name in String format, and values can be any allowed JavaScript type. This is an example of dataLayer with different data types:

<pre style="color: white">
dataLayer = [{ 
    'products': [{ 
            'name': 'Kala Ukulele',
            'tuning': 'High-G',
            'price': 449.75
        },{
            'name': 'Fender Stratocaster',
            'tuning': 'Drop-C',
            'price': 1699
    }],
    'stores': ['Los Angeles', 'New York'],
    'date': Sat Sep 13 2014 17:05:32 GMT+0200 (CEST),
    'employee': {'name': 'Reggie'}
}];
</pre>

Here we have values such as an Array of objects (the products), numerical values (price), an Array of Strings (stores), a date object, and a nested object (the employee name).

The point here is that dataLayer is generic and tool-agnostic. As long as it behaves like your typical JavaScript Array, it won't be restricted to just one tool. The information in the dataLayer object above can be used by any application which has access to the global namespace of this page.

How the data within this Array is processed is thus left to the tool. In Google Tag Manager, for example, an intermediate helper object is used to process data in dataLayer, which is then stored in an internal, abstract data model within the tool itself. This ensures that dataLayer can stay generic and tool-agnostic, but the data within is processed to comply with the idiosyncratic features of Google Tag Manager.

The helper object used by Google Tag Manager has a number of interesting features, such as:

A listener which listens for pushes to dataLayer. If a push occurs, the variables in the push are evaluated.

Get and set methods which process / manipulate dataLayer as a queue (first in, first out), and ensure that the special values (objects, Arrays) within the data model can be updated and appended correctly.

The ability to access commands and methods of objects stored in dataLayer, and the possibility of running custom functions in the context of the data model.

These are all transparent to Google Tag Manager's users, of course, but they explain why, for example, the Data Layer Variable Macro can access dotted variable names (gtm.element) and properties (gtm.element.id) equally, and also why you can push multiple values with the same key into dataLayer but only the most recently pushed value is available for tags which fire after the push.

Since the abstract data model within Google Tag Manager only respects the most recent value of any variable name, the organization must decide where and when Data Layer as a business component becomes dataLayer the Array structure. This is the topic of the next chapter.

# From Business Goals To Technical Implementation

<pre style="color: white">
 window.dataLayer = window.dataLayer || [];
    dataLayer.push({
        'userId' : 'abf5-3245-ffd1-23ed',
        'internalUser' : true,
        'weather' : 'Cloudy'
    });
</pre>

As you can see, the data is rendered before the GTM container snippet, so that all tags that fire as soon as GTM is loaded can use this data.

Do note that you can and will use dataLayer within the confines of Google Tag Manager as well, since your tags or other on-page libraries might well push data into the structure after this pre-load sequence. I don't think these dynamic pushes or data exchanges need to be documented as carefully, since they occur solely in the domain of the tool that does the pushes. Thus, documentation and version control is left up to the sophistication of the tool itself.

The reason you need to put a lot of thought behind the pre-rendered dataLayer is because each new stakeholder makes the question of governance a bit more complex.

## Governance Of The Data Layer

Coming up with a good governance model is difficult. Coming up with one for a data structure which is at the mercy of a number of different parties, all with varying levels of expertise (and general interest), is even more difficult.

Nevertheless, a well-defined, structured, and formalized governance model is probably the one thing that will prevent your analytics organization from imploding due to missteps in operating with a Data Layer.

A governance model, in this context, is a document (or documentation) which describes as clearly as possible the Data Layer, its parts, the business domains it's deployed in, its various owners, its version history, its variables, how risk management is handled, etc.

This is a very fluid concept, and it really depends on the organization how they want to organize themselves around this project, but ideally this is the kind of governance model I'd be happy to work with: