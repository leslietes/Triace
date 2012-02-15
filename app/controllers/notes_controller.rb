class NotesController < ApplicationController
before_filter :login_required
before_filter :get_products
def index
@notes = Note.find(:all, :include => [:product], :order => "close ASC, created_at ASC")
end

def new
@note = Note.new
end

def create
@note = Note.new(params[:note])
if @note.save
redirect_to notes_url, :notice => "Note added successfully."
else
render :action => 'new', :status => :unprocessable_entity
end
end

def edit
 @note = Note.find_by_id(params[:id])
end

def update
@note = Note.find_by_id(params[:id])
    if @note.update_attributes(params[:note])
      redirect_to notes_url, :notice => "Note successfully updated." 
    else
      render :action => 'edit'      
    end
end

def destroy
@note = Note.find_by_id(params[:id])
    if @note.destroy
      flash[:notice] = "Successfully deleted note"
    else
      flash[:error] = "Error in deleting note"
    end
    redirect_to notes_url
end

def close
@note = Note.find_by_id(params[:id])
if @note
@note.closed
end
redirect_to notes_url
end

end
