package evoTinyEngine.link
{
	import evoTinyEngine.modifier.AbstractModifier;

	public class LinkedListModifier
	{
		public var next:LinkedListModifier;
			
		public var first:AbstractModifier, last:AbstractModifier, c:AbstractModifier;
		
		public function LinkedListModifier() {}
		
		public function push(add:AbstractModifier):void
		{
			if(!first)
			{
				first = add; 
				last = add;
			}
			else
			{
				last.next = add;
				add.prev = last;
				last = add;
			}
		}
		
		public function dispose():void
		{
			first = null;
		}
		
		public function remove():void
		{
			next = null;
			first = null;
			last = null;
			c = null;
		}
		
	}
}