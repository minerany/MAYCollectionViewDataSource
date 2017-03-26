# MAYCollectionViewDataSource

#Installation

`pod 'MAYCollectionViewDataSource', :git => 'https://github.com/minerany/MAYCollectionViewDataSource.git'`

#Usage

For example create UITableView datasource

Import header file:

`#import "MAYCollectionViewDataSource+UITableView.h"`

Create a MAYCollectionViewDataSource instance and configure it:
	  
    MAYCollectionViewDataSource *dataSource = [MAYCollectionViewDataSource new];
    MAYCollectionViewCellSource *cellSource = [MAYCollectionViewCellSource sourceWithIdentifier:@"cell"];
    cellSource.data = @" hello miner";
    [cellSource setTarget:self configSelector:@selector(__configCustomCell:cellSource:)];
    [cellSource setTarget:self actionSelector:@selector(__performAction:cellSource:)];
    [dataSource addCellSource:@[cellSource]];
    
    
Use DECL_CONFIG_SEL and DECL_ACTION_SEL declare configSelector and actionSelector in interface extension

    MAYDeclareConfigCellSelector(__configCustomCell, UITableViewCell *, MAYCollectionViewCellSource*)
    MAYDeclareCellActionSelector(__performAction, UITableViewCell *, MAYCollectionViewCellSource*)
    
Then implementation config and action method
    
    - (void)__configCustomCell:(UITableViewCell *)cell cellSource:(MAYCollectionViewCellSource *)cellSource {
      cell.textLabel.text = cellSource.data;
    }

    - (void)__performAction:(UITableViewCell *)cell cellSource:(MAYCollectionViewCellSource *)cellSource {
      NSLog(@"%@",cellSource.data);
    }
   
And UITableView dataSource configuration done!

If you want to implement UITableView scrollviewDidScroll delegate method, you can set 

    dataSource.interceptedTableViewDelegate = self;
    
In this delegate, you can implemente UITableViewDelegate delegate method that you want.

MAYCollectionViewDataSource also support self-sizing TableViewCell, if you set

    tableView.rowHeight = UITableViewCellAutomaticHeight;
    
More Detail you can see in ExampleViewController
    
