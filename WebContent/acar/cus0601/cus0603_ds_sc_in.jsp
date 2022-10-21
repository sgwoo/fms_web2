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
		var SUBWIN="cus0601_ds_carhis.jsp?auth_rw=<%= auth_rw %>&car_mng_id="+cid;
		window.open(SUBWIN, "CarService", "left=100, top=120, width=830, height=400, scrollbars=no");
	}
//-->
</script>
</head>

<body onLoad="javascript:init()">
<table width="100%" border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0">
	            <tr id='tr_title' style='position:relative;z-index:1'>		            
                    <td width="391" class='line' id='td_title' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="473">
                            <tr> 
                                <td width='40' class='title' height="35" >연번</td>
                                <td width='83' class='title' >정비일자</td>
                                <td width='70' class='title' height="35" >정비구분</td>
                                <td width='84' class='title' >차량번호</td>
                                <td width='190' class='title' >고객명</td>
                            </tr>
                        </table>
                    </td>		
                    <td width="503" class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="598" >
                            <tr>
                                <td width='71' class='title'>점검자</td>
                                <td width='331' class='title'>정비품목</td>
                                <td width='99' class='title'>정비비</td>
                                <td width='92' class='title'>결제일</td>
                            </tr>
                        </table>
 		            </td>
	            </tr>
<%if(c61_slBns.length !=0 ){%>
	            <tr>
            
                    <td class='line' id='td_con' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="473" >
              <% for(int i=0; i< c61_slBns.length; i++){
		c61_slBn = c61_slBns[i];
	%>
                            <tr> 
                                <td width='38' align='center'><%=i+1%></td>
                                <td width='84' align='center'><%=AddUtil.ChangeDate2(c61_slBn.getServ_dt())%></td>
                                <td width='70' align='center'><%if(c61_slBn.getServ_st().equals("1")){
                													out.print("순회점검");
                												}else if(c61_slBn.getServ_st().equals("2")){
                													out.print("일반수리");
                												}else if(c61_slBn.getServ_st().equals("3")){
                													out.print("보증수리");
                												}else if(c61_slBn.getServ_st().equals("4")){
                													out.print("사고수리");
                												}%></td>
                                <td width='85' align='center'><a href="javascript:open_carhis('<%=c61_slBn.getCar_mng_id()%>');"><%=c61_slBn.getCar_no()%></a></td>
                                <td width='190' align='left'><span title="<%=c61_slBn.getFirm_nm()%>">&nbsp;<%=AddUtil.subData(c61_slBn.getFirm_nm(),12)%></span></td>
                            </tr>
                          <%}%>
                            <tr> 
                                <td  class='title' width='38' align='center'>&nbsp;</td>
                                <td  class='title' width='84' align='center'>&nbsp;</td>
                                <td  class='title' width='70' align='center'>&nbsp;</td>
                                <td  class='title' width='85' align='center'>&nbsp;</td>
                                <td  class='title' align='center'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="598" >
                          <% for(int i=0; i< c61_slBns.length; i++){
            			c61_slBn = c61_slBns[i];
            			sum_amt += AddUtil.parseLong(String.valueOf(c61_slBn.getTot_amt()));
            	%>
                            <tr>
                                <td width='71' align='center' ><%if(!c61_slBn.getChecker().equals("")){
                													if(c61_slBn.getChecker().substring(0,2).equals("00")){%> <%= login.getAcarName(c61_slBn.getChecker()) %> <%}else{%> <%= c61_slBn.getChecker() %> <% }
                												}%></td>
                                <td width='331' align='left' ><span title="<%= c61_slBn.getRep_cont() %>">&nbsp;&nbsp;<%= AddUtil.subData(c61_slBn.getRep_cont(),16) %></span></td>
                                <td width='99' align='right'><%= AddUtil.parseDecimal(c61_slBn.getTot_amt()) %>&nbsp;원&nbsp;&nbsp;</td>
                                <td width='93' align='center' ><%=AddUtil.ChangeDate2(c61_slBn.getSet_dt())%></td>
                            </tr>
                          <%}%>
                            <tr>
                                <td align='center'  class='title' >&nbsp;</td>
                                <td align='center'  class='title' >&nbsp;</td>
                                <td width='99' align='right' ><%= AddUtil.parseDecimal(sum_amt) %>&nbsp;원&nbsp;&nbsp;</td>
                                <td  class='title' width='93' align='center' >&nbsp;</td>
                            </tr>
                        </table>
            		</td>
            	</tr>
            <%}else{%>
            	<tr>	        
                    <td class='line' id='td_con' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="473" >
                            <tr> 
                                <td width="471" align='center'></td>
                            </tr>
                        </table>
                    </td>
            	    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="598" >
                            <tr> 
                                <td width="497"  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 
                              정비건이 없읍니다.</td>
                            </tr>          
                        </table>
            		</td>
            	</tr>
            <%}%>		
            </table>
        </td>
    </tr>
</table>
</body>
</html>
