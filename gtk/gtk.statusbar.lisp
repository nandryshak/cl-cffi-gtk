;;; ----------------------------------------------------------------------------
;;; gtk.statusbar.lisp
;;;
;;; This file contains code from a fork of cl-gtk2.
;;; See <http://common-lisp.net/project/cl-gtk2/>.
;;;
;;; The documentation of this file is taken from the GTK+ 3 Reference Manual
;;; Version 3.6.4 and modified to document the Lisp binding to the GTK library.
;;; See <http://www.gtk.org>. The API documentation of the Lisp binding is
;;; available from <http://www.crategus.com/books/cl-cffi-gtk/>.
;;;
;;; Copyright (C) 2009 - 2011 Kalyanov Dmitry
;;; Copyright (C) 2011 - 2013 Dieter Kaiser
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU Lesser General Public License for Lisp
;;; as published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version and with a preamble to
;;; the GNU Lesser General Public License that clarifies the terms for use
;;; with Lisp programs and is referred as the LLGPL.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU Lesser General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with this program and the preamble to the Gnu Lesser
;;; General Public License.  If not, see <http://www.gnu.org/licenses/>
;;; and <http://opensource.franz.com/preamble.html>.
;;; ----------------------------------------------------------------------------
;;;
;;; GtkStatusbar
;;;
;;; Report messages of minor importance to the user
;;;
;;; Synopsis
;;;
;;;     GtkStatusbar
;;;
;;;     gtk_statusbar_new
;;;     gtk_statusbar_get_context_id
;;;     gtk_statusbar_push
;;;     gtk_statusbar_pop
;;;     gtk_statusbar_remove
;;;     gtk_statusbar_remove_all
;;;     gtk_statusbar_get_message_area
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; struct GtkStatusbar
;;; ----------------------------------------------------------------------------

(define-g-object-class "GtkStatusbar" gtk-statusbar
  (:superclass gtk-box
   :export t
   :interfaces ("AtkImplementorIface"
                "GtkBuildable"
                "GtkOrientable")
   :type-initializer "gtk_statusbar_get_type")
 nil)

(setf (documentation 'gtk-statusbar 'type)
 "@version{2013-4-23}
  @begin{short}
    A @sym{gtk-statusbar} is usually placed along the bottom of an application's
    main @class{gtk-window} widget. It may provide a regular commentary of the
    application's status as is usually the case in a web browser, for example,
    or may be used to simply output a message when the status changes, when an
    upload is complete in an FTP client, for example.
  @end{short}

  Status bars in GTK+ maintain a stack of messages. The message at the top of
  the each bar's stack is the one that will currently be displayed.

  Any messages added to a statusbar's stack must specify a context id that is
  used to uniquely identify the source of a message. This context id can be
  generated by the function @fun{gtk-statusbar-get-context-id}, given a message
  and the statusbar that it will be added to. Note that messages are stored in a
  stack, and when choosing which message to display, the stack structure is
  adhered to, regardless of the context identifier of a message.

  One could say that a statusbar maintains one stack of messages for display
  purposes, but allows multiple message producers to maintain sub-stacks of
  the messages they produced (via context ids).

  Status bars are created using the function @fun{gtk-statusbar-new}.

  Messages are added to the bar's stack with the function
  @fun{gtk-statusbar-push}.

  The message at the top of the stack can be removed using the function
  @fun{gtk-statusbar-pop}. A message can be removed from anywhere in the stack
  if its message id was recorded at the time it was added. This is done using
  the function @fun{gtk-statusbar-remove}.
  @begin[Style Property Details]{dictionary}
    @subheading{The \"shadow-type\" style property}
      @code{\"shadow-type\"} of type @symbol{gtk-shadow-type} (Read)@br{}
      Style of bevel around the statusbar text.@br{}
      Default value: @code{:in}
  @end{dictionary}
  @begin[Signal Details]{dictionary}
    @subheading{The \"text-popped\" signal}
      @begin{pre}
 lambda (statusbar context-id text)   : Run Last
      @end{pre}
      Is emitted whenever a new message is popped off a statusbar's stack.
      @begin[code]{table}
        @entry[statusbar]{The object which received the signal.}
        @entry[context-id]{The context id of the relevant message/statusbar.}
        @entry[text]{The message that was just popped.}
      @end{table}
    @subheading{The \"text-pushed\" signal}
      @begin{pre}
 lambda (statusbar context-id text)   : Run Last
      @end{pre}
      Is emitted whenever a new message gets pushed onto a statusbar's stack.
      @begin[code]{table}
        @entry[statusbar]{The object which received the signal.}
        @entry[context-id]{The context id of the relevant message/statusbar.}
        @entry[text]{The message that was pushed.}
      @end{table}
  @end{dictionary}")

;;; ----------------------------------------------------------------------------
;;; gtk_statusbar_new ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-statusbar-new))

(defun gtk-statusbar-new ()
 #+cl-cffi-gtk-documentation
 "@version{2013-8-1}
  @return{The new @class{gtk-statusbar} widget.}
  Creates a new @class{gtk-statusbar} ready for messages."
  (make-instance 'gtk-statusbar))

(export 'gtk-statusbar-new)

;;; ----------------------------------------------------------------------------
;;; gtk_statusbar_get_context_id ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_statusbar_get_context_id" %gtk-statusbar-get-context-id) :uint
  (statusbar (g-object gtk-statusbar))
  (context-description :string))

(defun gtk-statusbar-get-context-id (statusbar context)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-23}
  @argument[statusbar]{a @class{gtk-statusbar} widget}
  @argument[context]{textual description of what context the new message is
    being used in}
  @return{An integer id.}
  @begin{short}
    Returns a new context identifier, given a description of the actual context.
  @end{short}
  Note that the description is not shown in the UI."
  (etypecase context
    (integer context)
    (string (%gtk-statusbar-get-context-id statusbar context))))

(export 'gtk-statusbar-get-context-id)

;;; ----------------------------------------------------------------------------
;;; gtk_statusbar_push ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_statusbar_push" %gtk-statusbar-push) :uint
  (statusbar (g-object gtk-statusbar))
  (context-id :uint)
  (text :string))

(defun gtk-statusbar-push (statusbar context-id text)
 #+cl-cffi-gtk-documentation
 "@version{2013-12-15}
  @argument[statusbar]{a @class{gtk-statusbar} widget}
  @argument[context-id]{the message's context ID, as returned by the function
    @fun{gtk-statusbar-get-context-id}}
  @argument[text]{the message to add to the @arg{statusbar}}
  @return{A message ID that can be used with the function
    @fun{gtk-statusbar-remove}.}
  Pushes a new message onto a statusbar's stack.
  @see-class{gtk-statusbar}
  @see-function{gtk-statusbar-remove}
  @see-function{gtk-statusbar-get-context-id}"
  (%gtk-statusbar-push statusbar
                       context-id
                       text))

(export 'gtk-statusbar-push)

;;; ----------------------------------------------------------------------------
;;; gtk_statusbar_pop ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_statusbar_pop" %gtk-statusbar-pop) :void
  (statusbar (g-object gtk-statusbar))
  (context-id :uint))

(defun gtk-statusbar-pop (statusbar context-id)
 #+cl-cffi-gtk-documentation
 "@version{2013-12-15}
  @argument[statusbar]{a @class{gtk-statusbar} widget}
  @argument[context-id]{a context identifier}
  @begin{short}
    Removes the first message in the @class{gtk-statusbar}'s stack with the
    given context ID.
  @end{short}

  Note that this may not change the displayed message, if the message at the
  top of the stack has a different context ID.
  @see-class{gtk-statusbar}
  @see-function{gtk-statusbar-push}"
  (%gtk-statusbar-pop statusbar
                      context-id))

(export 'gtk-statusbar-pop)

;;; ----------------------------------------------------------------------------
;;; gtk_statusbar_remove ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_statusbar_remove" %gtk-statusbar-remove) :void
  (statusbar (g-object gtk-statusbar))
  (context-id :uint)
  (message-id :uint))

(defun gtk-statusbar-remove (statusbar context message-id)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-23}
  @argument[statusbar]{a @class{gtk-statusbar} widget}
  @argument[context-id]{a context identifier}
  @argument[message-id]{a message identifier, as returned by the function
    @fun{gtk-statusbar-push}}
  @begin{short}
    Forces the removal of a message from a statusbar's stack. The exact
    @arg{context-id} and @arg{message-id} must be specified.
  @end{short}
  @see-function{gtk-statusbar-push}"
  (%gtk-statusbar-remove statusbar
                         (gtk-statusbar-get-context-id statusbar context)
                         message-id))

(export 'gtk-statusbar-remove)

;;; ----------------------------------------------------------------------------
;;; gtk_statusbar_remove_all ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_statusbar_remove_all" %gtk-statusbar-remove-all) :void
  (statusbar (g-object gtk-statusbar))
  (conext-id :uint))

(defun gtk-statusbar-remove-all (statusbar context)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-23}
  @argument[statusbar]{a @class{gtk-statusbar} widget}
  @argument[context-id]{a context identifier}
  @begin{short}
    Forces the removal of all messages from a statusbar's stack with the exact
    @arg{context-id}.
  @end{short}

  Since 2.22"
  (%gtk-statusbar-remove-all statusbar
                             (gtk-statusbar-get-context-id statusbar context)))

(export 'gtk-statusbar-remove-all)

;;; ----------------------------------------------------------------------------
;;; gtk_statusbar_get_message_area ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_statusbar_get_message_area" gtk-statusbar-get-message-area)
    (g-object gtk-widget)
 #+cl-cffi-gtk-documentation
 "@version{2013-4-23}
  @argument[statusbar]{a @class{gtk-statusbar} widget.}
  @return{A @class{gtk-box} widget.}
  @begin{short}
    Retrieves the box containing the label widget.
  @end{short}

  Since 2.20"
  (statusbar (g-object gtk-statusbar)))

(export 'gtk-statusbar-get-message-area)

;;; --- End of file gtk.statusbar.lisp -----------------------------------------
