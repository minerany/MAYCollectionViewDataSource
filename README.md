# MAYCollectionViewDataSource

#Installation

`pod 'MAYCollectionViewDataSource'`

#Usage

For example create UITableView datasource

Import header file:

`#import "MAYCollectionViewDataSource+UITableView.h"`

Create a MAYCollectionViewDataSource instance and configure it:
	  
    MAYCollectionViewDataSource *dataSource = [[MAYCollectionViewDataSource alloc] initWithView:_tableView];
    MAYCollectionViewCellSource *cellSource = [MAYCollectionViewCellSource sourceWithIdentifier:@"cell"];
    cellSource.data = @"hello miner";
    [cellSource setTarget:self configSelector:@selector(__configCustomCell:cellSource:)];
    [cellSource setTarget:self actionSelector:@selector(__performAction:cellSource:)];
    [dataSource addCellSource:@[cellSource]];
    
    
Use DECL_CONFIG_SEL and DECL_ACTION_SEL declare configSelector and actionSelector in interface extension

    DECL_CONFIG_SEL(__configCustomCell, UITableViewCell *, MAYCollectionViewCellSource*)
    DECL_ACTION_SEL(__performAction, UITableViewCell *, MAYCollectionViewCellSource*)
    
Then implementation config and action method
    
    - (void)__configCustomCell:(UITableViewCell *)cell cellSource:(MAYCollectionViewCellSource *)cellSource {
      cell.textLabel.text = cellSource.data;
    }

    - (void)__performAction:(UITableViewCell *)cell cellSource:(MAYCollectionViewCellSource *)cellSource {
      NSLog(@"%@",cellSource.data);
    }
   
And UITableView datasource configuration done!

If you want to implemente UITableView scrollviewDidScroll delegate method, you can use 

    - (instancetype)initWithTableView:(UITableView *)tableView interceptedTableViewDelegate:(id <UITableViewDelegate>)delegate;
    
In this delegate, you can implemente UITableViewDelegate delegate method that you want.

More Detail you can see in ExampleViewController
    
