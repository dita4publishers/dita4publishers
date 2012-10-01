(function (d4p) {

cUri: '',

        ids: 0,

        getDialogId: function () {
            this.ids++;
            return this.ids;
        },

        dialog: function (obj) {

            var uri = obj.attr('href')
                .substring(1);
            var id = d4p.ui.getDialogId();

            // keep track of every external dialog loaded
            if (d4p.ui.processed[uri] == undefined) {
                d4p.ui.processed[uri] = {
                    'id': id,
                    'uri': obj.attr('href')
                        .substring(1),
                    'done': false
                };
            }

            // avoid processing url twice
            if (d4p.ui.processed[uri].done == true) {
                var href = obj.attr('href');
                if (obj.attr('href') != "") {
                    var rid = d4p.ui.processed[uri].id;
                    // remove href
                    obj.attr('href', "");
                    obj.attr('target', "#dialog-" + rid);

                    // add click handler
                    obj.click(function () {
                        $($(this)
                            .attr('target'))
                            .dialog('open');
                    });
                }
                return true;
            }

            // add dialog
            var dialog = $("<div />")
                .attr("id", "dialog-" + id);

            $(d4p.ajax.loaderParentElement)
                .append(dialog);
            dialog.dialog({
                autoOpen: false,
                minWidth: d4p.ui.dialogMinWidth
            });
            dialog.dialog('close');

            // remove href
            obj.attr('href', "");
            obj.attr('target', "#dialog-" + id);

            // add click handler
            obj.click(function () {
                $($(this)
                    .attr('target'))
                    .dialog('open');
            });

            $.ajax({
                url: uri,
                complete: function (jqXHR, status, responseText) {
                    // Store the response as specified by the jqXHR object
                    responseText = jqXHR.responseText;

                    // If successful, inject the HTML into all the matched elements
                    if (jqXHR.isResolved()) {

                        // From jquery: #4825: Get the actual response in case
                        // a dataFilter is present in ajaxSettings
                        jqXHR.done(function (r) {
                            responseText = r;
                        });

                        var html = $("<div>")
                            .append(responseText.replace(d4p.rscript, ""));

                        var content = html.find(d4p.externalContentElement);
                        // remove links from content because it is weird to jump
                        // from a dialog to a page
                        content.find("a")
                            .each(function (index) {
                            $(this)
                                .replaceWith(this.childNodes);
                        });
                        var title = html.find("title")
                            .html();

                        // update dialog
                        var id = d4p.ui.processed[uri].id;
                        var dialog = $("#dialog-" + id);
                        dialog.attr("title", title);
                        dialog.append($("<p />")
                            .html(content));

                    }
                }
            });

            d4p.ui.processed[uri].done = true;
        },
        