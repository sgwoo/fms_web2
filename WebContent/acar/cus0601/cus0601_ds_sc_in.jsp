<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.cus0601.*" %>
<jsp:useBean id="c61_slBn" class="acar.cus0601.ServListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String year = request.getParameter("year")==null?"2007":request.getParameter("year");
	String month = request.getParameter("month")==null?"":request.getParameter("month");
	
	
	LoginBean login = LoginBean.getInstance();
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	ServListBean[] c61_slBns = c61_db.getServList(s_kd, t_wd, sort_gubun, sort, off_id, year, month);
	
	long sum_amt = 0;	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init()
	{		
		setupEvents();
	}
	function open_carhis(cid){
		var SUBWIN="cus0601_ds_carhis.jsp?auth_rw=<%= auth_rw %>&off_id=<%= off_id %>&car_mng_id="+cid;
		window.open(SUBWIN, "CarService", "left=100, top=120, width=830, height=500, scrollbars=yes");
	}
	function open_carServ(c_id, serv_id){
		var SUBWIN="/acar/cus_reg/serv_reg_view.jsp?auth_rw=<%= auth_rw %>&off_id=<%= off_id %>&car_mng_id="+c_id+"&serv_id="+serv_id;
		window.open(SUBWIN, "CarService", "left=100, top=10, width=830, height=800, scrollbars=yes");
	}
//-->
</script>
</head>

<body onLoad="javascript:init()">
<table width="1350" border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
	            <tr id='tr_title' style='position:relative;z-index:1'>		            
                    <td width="600" class='line' id='td_title' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='50' class='title'>연번</td>
                                <td width='90' class='title'>정비일자</td>
                                <td width='140' class='title'>입고일시</td>
                                <td width='140' class='title'>출고일시</td>
                                <td width='90' class='title'>정비구분</td>
                                <td width='90' class='title'>차량번호</td>
                            </tr>
                        </table>
                    </td>		
                    <td width="750" class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width='200' class='title'>고객명</td>
                                <td width='60' class='title'>점검자</td>
                                <td width='300' class='title'>정비품목</td>
                                <td width='100' class='title'>정비비</td>
                                <td width='90' class='title'>결제일</td>
                            </tr>
                        </table>
 		            </td>
	            </tr>
<%if(c61_slBns.length !=0 ){%>
	            <tr>
            
                    <td class='line' id='td_con' style='position:relative;' width="600"> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <% for(int i=0; i< c61_slBns.length; i++){
		c61_slBn = c61_slBns[i];
	%>
                            <tr> 
                                <td width='50' align='center'><%=i+1%></td>
                                <td width='90' align='center'><%=AddUtil.ChangeDate2(c61_slBn.getServ_dt())%></td>
                                <td width='140' align='center'><%=AddUtil.ChangeDate3(c61_slBn.getIpgodt())%></td>
                                <td width='140' align='center'><%=AddUtil.ChangeDate3(c61_slBn.getChulgodt())%></td>
                                <td width='90' align='center'>
                                	 <%		if(c61_slBn.getServ_st().equals("1")){
                													out.print("순회점검");
                												}else if(c61_slBn.getServ_st().equals("2")){
                													out.print("일반수리");
                												}else if(c61_slBn.getServ_st().equals("3")){
                													out.print("보증수리");
                												}else if(c61_slBn.getServ_st().equals("4")){
                													out.print("계기판교환");
                												}else if(c61_slBn.getServ_st().equals("7")){
                													out.print("재리스정비");
                												}else if(c61_slBn.getServ_st().equals("11")){
                													out.print("신차영업관련");
                												}else if(c61_slBn.getServ_st().equals("12")){
                													out.print("해지");
                												}else if(c61_slBn.getServ_st().equals("13")){
                													out.print("자차");
                												}
                										%></td>
                                <td width='90' align='center'>
                                	
                                	<a href="javascript:open_carServ('<%=c61_slBn.getCar_mng_id()%>','<%=c61_slBn.getServ_id()%>');"><%=c61_slBn.getCar_no()%></a>
                                </td>
                            </tr>
                          <%}%>
                            <tr> 
                                <td  class='title' width='50' align='center'>&nbsp;</td>
                                <td  class='title' width='90' align='center'>&nbsp;</td>
                                <td  class='title' width='140' align='center'>&nbsp;</td>
                                <td  class='title' width='140' align='center'>&nbsp;</td>
                                <td  class='title' width='90' align='center'>&nbsp;</td>
                                <td  class='title' width='90' align='center'>&nbsp;</td>
                            </tr>
                         </table>
                    </td>
                    <td class='line' width="750"> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                          <% for(int i=0; i< c61_slBns.length; i++){
            			c61_slBn = c61_slBns[i];
            			sum_amt += AddUtil.parseLong(String.valueOf(c61_slBn.getTot_amt()));
            	%>
                            <tr>
                                <td width='200' align='left'><span title="<%=c61_slBn.getFirm_nm()%>">&nbsp;<%=AddUtil.subData(c61_slBn.getFirm_nm(),12)%></span></td>
                                <td width='60' align='center'><%if(!c61_slBn.getChecker().equals("")){
                													if(c61_slBn.getChecker().substring(0,2).equals("00")){%> <%= login.getAcarName(c61_slBn.getChecker()) %> <%}else{%> <%= c61_slBn.getChecker() %> <% }
                												}%></td>
                                <td width='300' align='left'><span title="<%= c61_slBn.getRep_cont() %>">&nbsp;&nbsp;<%= AddUtil.subData(c61_slBn.getRep_cont(),16) %></span></td>
                                <td width='100' align='right'><%= AddUtil.parseDecimal(c61_slBn.getTot_amt()) %></td>
                                <td width='90' align='center'><%=AddUtil.ChangeDate2(c61_slBn.getSet_dt())%></td>
                            </tr>
                          <%}%>
                            <tr>
                                <td align='center' width='200' class='title'>&nbsp;</td>
                                <td align='center' width='60' class='title'>&nbsp;</td>                                
                                <td align='center' width='300' class='title'>&nbsp;</td>
                                <td width='100' style='text-align:right' class='title'><%= AddUtil.parseDecimal(sum_amt) %></td>
                                <td  class='title' width='90' align='center'>&nbsp;</td>
                            </tr>
                        </table>
            		</td>
            	</tr>
            <%}else{%>
            	<tr>	        
                    <td class='line' id='td_con' style='position:relative;' width="600"> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
            	    <td class='line' width="750"> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 
                              정비건이 없읍니다.</td>
                            </tr>          
                        </table>
            		</td>
            	</tr>
            </table>
        </td>
    </tr>
<%}%>		
</table>
</body>
</html>
