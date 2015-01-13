//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
NSString*	StartPrivateChat			(PFUser *user1, PFUser *user2);

//-------------------------------------------------------------------------------------------------------------------------------------------------
void        CreateMessageItem           (PFUser *user, PFUser *chatter, NSString *roomId, NSString *description);
void		DeleteMessageItem			(PFObject *message);

//-------------------------------------------------------------------------------------------------------------------------------------------------
void		UpdateMessageCounter		(NSString *roomId, NSString *lastMessage);
void		ClearMessageCounter			(NSString *roomId);