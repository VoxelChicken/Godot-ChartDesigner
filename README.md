# Download

There's two ways of doing it:  
Through the **Godot Asset Library**, and **GitHub**.

## Through the Godot Asset Library

This one's relatively easy. You most likely came from there.  
What you do, is go back to the **Godot Asset Library**, and then search for my product (*Chart Designer*) and then click on it.

> Note:
>
> Make sure you type '*Chart Designer*', and not 'ChartDesigner' (since the search is 'space-sensitive'). Otherwise, the Godot Asset Library won't find the add-on.  
> Additionally, capitalization does *NOT* matter.

Now that you have found my add-on in the *Godot Asset Library* (if you haven't already), you see (obviously the name), the add-on's tags, the description, screenshots and some buttons. They, as of now, include:  
	- 'View files'  
	- 'Download'  
	- 'Submit an Issue'  
	- 'Recent Edits'

What we're aiming for is the **Download** button. Click on that, and then your file manager should appear.  
Simply select your desired destination of the file, download the add-on, extract it in that folder, and there you should, if you open the folder, see the add-on in the folder path and then in the *addons/chartdesigner* folder.

Then, when you'd like to add it to one of your projects (if you haven't directly added it to one yet), simply add the addons folder to your desired project and there you go!  
*That's that!*

## Through GitHub

This one's slightly more advanced, since you will use the terminal for this tutorial, but you get slightly more out of it. Since the *Godot Asset Library* doesn't give you the *entire GitHub repository*, but only the *addons* folder.  
With the **GitHub method**, you can get your hands on the *entire project*. Since you require the terminal for this, it's easier if I write this down in concrete steps, as follows:

> __Step 1 (optional):__
>>
>> Create a *new folder*. It can be called whatever you want. Since cloning the repo via the terminal creates another folder anyway, this step is only optional.

> __Step 2:__
>>
>> Open the *terminal*.

> __Step 3:__
>>
>> Navigate into your (newly created) *folder* using the *terminal*. This folder can also simply be where your other Godot Projects are located in.  
>> Addditionally, make sure you are in that folder.

> __Step 4:__
>>
>> Type in '*gh repo clone VoxelChicken/Godot-ChartDesigner*'. This means:  
>> *GitHub repository clone VoxelChicken / Godot ChartDesigner.*

> __Step 5:__
>>
>> Now that the repository is cloned, you can exit the terminal. Navigate into the project folder using your file manager.

> __Step 6: (optional)__
>>
>> You can manage the files to your liking. For example, you can use the project.godot file to test the add-on out and mess around with it.

This will get you the entire repository, not just the add-on. So also the 'Sample project' (developer's testing space)

That's it for the *GitHub cloning* tutorial! On to the *Setting up* tutorial!



# Setting up

This is the actual *application* tutorial of the add-on. This is an overview of what it has to offer and what you can manipulate in the Godot built-in editor:

## Editor Variables (Exported Variables)

The following variables are exported variables that you can see in the built-in Godot editor, here's a list:

> Type
>>
>> With this enum, you can select either a Bar Chart or a Line Graph.

> Values
>>
>> The values that will appear in the Graph. It's a PackedFloat64Array.

> Line Color
>>
>> Choose the color of the main line / bars.

> Line Width
>>
>> Controls the main line width.

> Distance to Y
>>
>> The distance of the Line and Bar Chart ends to the edge of the ChartDesigner. The higher the number is, the more 'squished' tje lines and bars are and amount in the center of the ChartDesigner.

> X Y Lines Color
>>
>> This color chooses the color for the axes-lines (x and y lines on the bottom and the left hand side).

> X Y Lines Width
>>
>> The width of the X and Y axes lines on the bottom and left side of the ChartDesigner.

> Number Labels
>>
>> With this checkbox, you can decide if numbers that indicate values show up on the bottom and left side of the ChartDesigner.

> Number Font Size
>>
>> The font size of the numbers.

> Number Color
>>
>> The color for the numbers.

> Number Adjustment
>>
>> Adjusts the number labels for the left-hand side of the ChartDesigner on the x axis.

> Helper Line Amount
>>
>> The amount of the Helper Lines. It's highly recommendable to have a proper amount, since it can otherwise lead to never-ending numbers that ruin the asthetic.

> Helper Line Color
>>
>> The color of the Helper Lines.

> Helper Line Width
>>
>> The width of the Helper Lines.

> Background Color
>>
>> The color for the background of the ChartDesigner. Somewhat transparent colors are recommended.

> Antialiasing
>
>> The antialiasing option for the entire ChartDesigner.

# Finishing up

Now, to use the ChartDesigner, simply add a ChartDesigner node into the desired scene and voila! You have a ChartDesigner.

## Any Errors? Any Questions?

Go to GitHub and submit a new discussion / issue under the *issues* tab in the repository for the Chart Designer.

---

And all should be done! Have fun with the add-on! :D
