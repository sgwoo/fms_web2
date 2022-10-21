<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.cus0601.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>
<%
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	ServOffBean[] c61_soBns = c61_db.getServ_offList2(s_kd, t_wd, sort_gubun, sort, "2", use_yn);	
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
//-->
</script>
</head>

<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width=1200>  
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=1200>
	            <tr id='tr_title' style='position:relative;z-index:1'>		            
                    <td class='line' id='td_title' style='position:relative;' width=24%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width=15% class=title>연번</td>
                                <td width=55% class='title'>상호</td>
                                <td width=30% class='title'>대표자</td>
                            </tr>
                        </table>
                    </td>		
                    <td class='line' width=76%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100% >
                            <tr>
                                <td width='14%' class='title'>사업자번호</td>
                                <td width='13%' class='title'>업태</td>
                                <td width='15%' class='title'>종목</td>
                                <td width='12%' class='title'>전화번호</td>
                                <td width='12%' class='title'>팩스번호</td>
                                <td width="34%" class='title'>주소</td>
                            </tr>
                        </table>
 		            </td>
	            </tr>
<%if(c61_soBns.length !=0 ){%>
	            <tr>
            
                    <td class='line' id='td_con' style='position:relative;' width=24%> <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <% for(int i=0; i< c61_soBns.length; i++){
					c61_soBn = c61_soBns[i];
					
					if(from_page.equals("/agent/consignment/cons_i_c.jsp") && (c61_soBn.getOff_nm().equals("코리아탁송")))	continue;
					
					if((c61_soBn.getOff_nm().equals("하이카콤(대전)"))&&(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")))>=20190701){
						continue;	//2019-07-01 부터는 하이카콤(대전) 사용x(20190627)
					}
	%>
                <tr> 
                    <td width='15%' align='center'><%=i+1%></td>
                    <td width='55%' align='left'><span title='<%=c61_soBn.getOff_nm()%>'>&nbsp;<a href="javascript:parent.view_detail('<%=c61_soBn.getOff_id()%>','<%=c61_soBn.getOff_nm()%>')"><%=AddUtil.subData(c61_soBn.getOff_nm(),10)%></a></span></td>
                    <td width='30%' align='center'><span title="<%=c61_soBn.getOwn_nm()%>"><%=AddUtil.subData(c61_soBn.getOwn_nm(),3)%></span></td>
                </tr>
              <%}%>
                <tr> 
                    <td  class='title' width='15%' align='center'>&nbsp;</td>
                    <td  class='title' width='55%' align='center'>&nbsp;</td>
                    <td  class='title' width='30%' align='center'>&nbsp;</td>
                </tr>
            </table>
        </td>
        <td class='line' width=76%> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <% for(int i=0; i< c61_soBns.length; i++){
					c61_soBn = c61_soBns[i];			
					
					if(from_page.equals("/agent/consignment/cons_i_c.jsp") && (c61_soBn.getOff_nm().equals("코리아탁송")))	continue;
					
					if((c61_soBn.getOff_nm().equals("하이카콤(대전)"))&&(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")))>=20190701){
						continue;	//2019-07-01 부터는 하이카콤(대전) 사용x(20190627)
					}
	%>
                <tr>
                    <td width='14%' align='center' ><%=AddUtil.ChangeEnt_no(c61_soBn.getEnt_no())%></td>
                    <td width='13%' align='center'><span title="<%= c61_soBn.getOff_sta() %>"><%=AddUtil.subData(c61_soBn.getOff_sta(),5)%></span></td>
                    <td width='15%' align='center'><span title="<%= c61_soBn.getOff_item() %>"><%=AddUtil.subData(c61_soBn.getOff_item(),6)%></span></td>
                    <td width='12%' align='center' ><%=c61_soBn.getOff_tel()%></td>
                    <td width='12%' align='center' ><%=c61_soBn.getOff_fax()%></td>
                    <td width="34%" align='left' ><span title="<%=c61_soBn.getOff_post()%>&nbsp;<%=c61_soBn.getOff_addr()%>">&nbsp;<%=c61_soBn.getOff_post()%>&nbsp;<%=AddUtil.subData(c61_soBn.getOff_addr(),20)%></span></td>
                </tr>
              <%}%>
                <tr>
                    <td  class='title' width='14%' align='center' >&nbsp;</td>
                    <td  class='title' width='13%' align='center' >&nbsp;</td>
                    <td  class='title' width='15%' align='center' >&nbsp;</td>
                    <td  class='title' width='12%' align='center' >&nbsp;</td>
                    <td  class='title' width='12%' align='center' >&nbsp;</td>
                    <td width='34%' align='center'  class='title' >&nbsp;</td>
                </tr>
            </table>
        </td>
	</tr>
<%}else{%>
	<tr>	        
        <td class='line' id='td_con' style='position:relative;' width=24%> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'></td>
                </tr>
            </table>
        </td>
	    <td class='line' width=76%> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 업체가 없읍니다.</td>
                </tr>          
            </table>
		</td>
	</tr>
<%}%>		
</table>
</body>
</html>
