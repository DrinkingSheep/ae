��� ����������� ������������� ����� ������ �������� �������: TTableListViewW - ��� ���������� ��� ������� ListView, ��� ���� ��������� ��������, ������� ��������� ������� ����� ���������, ��� ������ ListView ������� (��� ���� �� TOpenDialog, ��� � ������ ��� ������). � ��������, ���� WideString �� �����, �� ������������� TTableListVIewW �� ���������� �� ��������.
� ��� ��� WideString ����� ������ ���������: 
��� ������ � Item'�� ������ ���� ����������� �������� MakeWideCaption. � ���� ����� ������ �������� �� ����� �����, �� ������������ StringOf.
�������:
TableListView.Items.Add(TableListView.MakeWideCaption( FileName ));
TableListView.SubItems.Add(TableListView.MakeWideCaption( FileName ));
...
MessageBoxW( ... TableListView.StringOf(TableListView.Items[0].Caption) ... );

p.s: StringOf ����� ������������ �� ����������� �� �����, ������������� MakeWideCaption, ��� ����� �������� � �� ����� ������.