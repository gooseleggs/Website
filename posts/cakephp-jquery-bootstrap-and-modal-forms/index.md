---
title: "Cakephp JQuery Bootstrap and Modal forms"
date: 2021-12-09
tags: 
  - "cakephp"
  - "programming"
description: Create a pop-up modal form to edit with Cake-PHP
author: Me
---

Wanted to create a pop-up modal form to edit, view and create database information.  The default is, of course, to go to a new page.  I thought that I would try and work through it to make it more HTML2.0 like.  Here is what you need to do...

### Set up the main view

First off, we need to set up the main view to hold the modal dialog code.  So, in the _index.php_ template, or whatever main view template you want to do, add the following code to define the modal dialog box...

```html
<!-- Modal -->
<div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog modal-lg">
     
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="modal-title">Popup Window</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
 
            </div>
 <!--            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div> -->
        </div>
       
    </div>
</div>
```

We also need to add some Javascript to the template file. We do this as blocks to ensure it is loaded after the JQuery library is loaded. The following shows two types of ways to include the scripts. One we load in, and the other is inline. Note, that we don't need the \`test\` file in this blog, but shows how to load it in should you want to do this instead of being inline. Note: it is best practice to not have javascript inline any longer.

```php
<?= $this->Html->script('test', ['block' => 'script']);?>
 
<?php $this->Html->scriptStart(['block' => true]);?>
$(document).ready(function() {
        $('.openPopup').on('click',function(){
        var title = $(this).attr('data-title');
        var dataURL = $(this).attr('data-href');
        $('.modal-title').text(title);
        $('.modal-body').load(dataURL,function(){
            $('#myModal').modal({show:true});
        });
    }); 
});
<?php $this->Html->scriptEnd();?>
```

To make use of this, we need to define two items in the button, or link to open the code. The first parameter is \`data-title\` which has the title of the modal box. \`data-href is the URL of the page to be loaded into the modal dialog box. Examples of this

Note that when using Cake, we don't use the button type, as this triggers a connection to the backend server
```php
<?= $this->Html->tag('a', __('Rename'), ['class' => 'btn btn-xs btn-outline-primary openPopup', 'escape' => false, 'data-title'=>'Edit Framework', 'data-href'=>'/admin/frameworks/edit/'.$framework->id]) ?>
```
```html
<a href="javascript:void(0);" data-title="This is a title" data-href="/admin/framework-subcontrols/edit/04eff439-88be-4765-b6e8-aed6102f7e4f" class="openPopup">About Us</a>

```
```html
<a class="btn btn-xs btn-outline-primary openPopup" data-href="<?= $this->Url->build(['controller' => 'FrameworkSubcontrols', 'action' => 'view', $frameworkSubcontrols->id]); ?>">view</a>
```

Ensure that you have the openPopup class element on each button that is used, to trigger the modal dialog box.

To close the modal dialog box, use the following code snippet in the view

```html
<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
```
