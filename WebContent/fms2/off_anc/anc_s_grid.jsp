<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String comst = request.getParameter("comst") ==null?"":request.getParameter("comst");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	int count = 0;
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));
	
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-125;
	String acar_id = ck_acar_id;
	
	OffAncDatabase oad = OffAncDatabase.getInstance();

	
	AncBean a_r [] = oad.getAncAll2( "",  "",  "",  acar_id);
	
	JSONObject jObj = new JSONObject();
	
	if(a_r.length > 0){
	    
	    Collection<JSONObject> items = new ArrayList<JSONObject>();
	    
	    for(int i=0; i<a_r.length; i++){
	        a_bean = a_r[i];
	        JSONArray jarr = new JSONArray();
	        JSONObject sObj = new JSONObject();
	        
	        jarr.add(i+1);
	        jarr.add(a_bean.getTitle());
	        jarr.add(a_bean.getUser_nm());
	        jarr.add(a_bean.getDept_nm());
	        jarr.add(a_bean.getReg_dt());
	        jarr.add(a_bean.getExp_dt());
	        jarr.add(a_bean.getComment_cnt());
	        jarr.add(a_bean.getBbs_id());
	        jarr.add(a_bean.getBbs_st());
	        
	        sObj.put("id",i+1);
	        sObj.put("data",jarr);
	        
	        items.add(sObj);
	    }
	    jObj.put("rows",items);
	}
	
	String jobjString = jObj.toString();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>

<!--Grid-->
<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="../lib/dhtmlx/dhtmlx.css" />
<link rel="stylesheet" type="text/css" href="../lib/dhtmlx/skins/terrace/dhtmlx.css"/>
<script src="../lib/dhtmlx/dhtmlx.js"></script>
<script src="../lib/dhtmlx/dhtmlx_deprecated.js"></script>
<!--Grid-->

<script language="JavaScript">

function parsingGridData(){
	var data = $.parseJSON('<%=jobjString%>');
    mygrid(data);
}

function mygrid(data){
      
      myGrid = new dhtmlXGridObject('gridbox');
      myGrid.setImagePath("/resources/libs/dhtmlx/skins/terrace/imgs/dhxgrid_terrace/");
      myGrid.setHeader("no,title,reg_nm,dept_nm,reg_dt,exp_dt,comment_cnt");      	
      //myGrid.setInitWidths("100,400,100,100,100,100,100"); 	
      myGrid.setInitWidths("10%,40%,10%,10%,10%,10%,10%"); 	
      myGrid.setColSorting("int,str,str,str,str,str,int");	
      myGrid.attachHeader(" ,#text_filter,#select_filter,#select_filter,#text_filter,#text_filter, ");
      myGrid.setColAlign("left"); 				
      myGrid.init(); 										
      myGrid.enableColumnMove(true);      
      myGrid.enableSmartRendering(true);	
      myGrid.parse(data,"json");					

}


//-->
</script>
</head>
<body onload="javascript:parsingGridData();"> 
	<table border=0 cellspacing=0 cellpadding=0 width=100%>
		<tr>
			<td colspan=2>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
						<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5>��������</span></span></td>
						<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h ></td>
		</tr>
</table>			
<div id="gridbox" style="width:98%;min-height:90%; margin:20px; background-color:white;"></div>

</body>
</html>