/* paging */

package acar.util;

import java.util.*;
import java.io.*;
import java.sql.*;
import java.text.*;
import java.lang.*;

public class PagingUtil {
	public static PagingBean setPagingInfo(PagingBean paging){
		paging.setCountPerPage(12);
		paging.setBlockCount(10);
		paging.setStartNum(paging.getTotalCount() - (paging.getNowPage()-1) * paging.getCountPerPage());
		return paging;
	}
}
