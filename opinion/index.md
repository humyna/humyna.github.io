---
layout: home
---

<div class="index-content opinion">
    <div class="section">
        {% include artical-cate-opinion.html %}

        <ul class="artical-list">
        {% for post in site.categories.opinion %}
            <li>
                <h2>
                    <a href="{{ post.url }}">{{ post.title }}</a>
                </h2>
                <div class="title-desc">{{ post.description }}</div>
            </li>
        {% endfor %}
        </ul>
    </div>
    <div class="aside">
    </div>
</div>
