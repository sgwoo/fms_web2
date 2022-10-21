<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<%@ page import="acar.cus0601.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	ServOffBean[] c61_soBns = c61_db.getServ_offList(s_kd, t_wd, sort_gubun, sort);	
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
<table border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td>
<table border="0" cellspacing="0" cellpadding="0">
	<tr id='tr_title' style='position:relative;z-index:1'>		
            
          <td width="519" class='line' id='td_title' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width="444">
              <tr> 
                <% if(!auth_rw.equals("1")){ %>
                <td width='33' class='title' >&nbsp;</td>
                <% } %>
                <td width='33' class='title' height="35" >연번</td>
                <td width='85' class='title' >지정업체</td>
                <td width='52' class='title' height="35" >등급</td>
                <td width='162' class='title' >상호</td>
                <td width='72' class='title' height="35" >대표자</td>
              </tr>
            </table></td>		
    <td width="630" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="997" >
              <tr>
                <td width='67' class='title'>총정비건수</td>
                <td width='98' class='title'>총정비금액</td>
                <td width='114' class='title'>사업자번호</td>
                <td width='100' class='title'>업태</td>
                <td width='93' class='title'>종목</td>
                <td width='95' class='title'>전화번호</td>
                <td width='94' class='title'>팩스번호</td>
                <td width="327" class='title'>주소</td>
              </tr>
            </table>
 		</td>
	</tr>
<%if(c61_soBns.length !=0 ){%>
	<tr>
            
          <td class='line' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width="444" >
              <% for(int i=0; i< c61_soBns.length; i++){
		c61_soBn = c61_soBns[i];
	%>
              <tr> 
                <% if(!auth_rw.equals("1")){ %>
                <td width='33' align='center'>
                  <% if(c61_soBn.getServ_cnt()==0){ %>
                  <a href="javascript:parent.ServOffDel('<%=c61_soBn.getOff_id()%>')" onMouseOver="window.status=''; return true"> 
                  D </a>
                  <% } %>
                </td>
                <% } %>
                <td width='33' align='center'><%=i+1%></td>
                <td width='85' align='center'><%=c_db.getNameById(c61_soBn.getCar_comp_id(),"CAR_COM")%></td>
                <td width='52' align='center'><%=c61_soBn.getOff_st()%>급</td>
                <td width='162' align='left'><span title='<%=c61_soBn.getOff_nm()%>'>&nbsp;<a href="javascript:parent.view_detail('<%=c61_soBn.getOff_id()%>')"><%=AddUtil.subData(c61_soBn.getOff_nm(),10)%></a></span></td>
                <td width='72' align='center'><span title="<%=c61_soBn.getOwn_nm()%>"><%=AddUtil.subData(c61_soBn.getOwn_nm(),3)%></span></td>
              </tr>
              <%}%>
              <tr> 
                <% if(!auth_rw.equals("1")){ %>
                <td  class='title' width='33' align='center'>&nbsp;</td>
                <% } %>
                <td  class='title' width='33' align='center'>&nbsp;</td>
                <td  class='title' width='85' align='center'>&nbsp;</td>
                <td  class='title' width='52' align='center'>&nbsp;</td>
                <td  class='title' width='162' align='center'>&nbsp;</td>
                <td  class='title' align='center'>&nbsp;</td>
              </tr>
            </table></td>
    <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width="998" >
              <% for(int i=0; i< c61_soBns.length; i++){
			c61_soBn = c61_soBns[i];			
	%>
              <tr>
                <td width='67' align='right' ><%=AddUtil.parseDecimal(c61_soBn.getServ_cnt())%></td>
                <td width='98' align='right' ><%=AddUtil.parseDecimal(c61_soBn.getServ_amt())%></td>
                <td width='114' align='center' ><%=AddUtil.ChangeEnt_no(c61_soBn.getEnt_no())%></td>
                <td width='100' align='center'><span title="<%= c61_soBn.getOff_sta() %>"><%=AddUtil.subData(c61_soBn.getOff_sta(),5)%></span></td>
                <td width='93' align='center'><span title="<%= c61_soBn.getOff_item() %>"><%=AddUtil.subData(c61_soBn.getOff_item(),6)%></span></td>
                <td width='95' align='center' ><%=c61_soBn.getOff_tel()%></td>
                <td width='94' align='center' ><%=c61_soBn.getOff_fax()%></td>
                <td width="328" align='left' ><span title="<%=c61_soBn.getOff_post()%>&nbsp;<%=c61_soBn.getOff_addr()%>">&nbsp;<%=c61_soBn.getOff_post()%>&nbsp;<%=AddUtil.subData(c61_soBn.getOff_addr(),20)%></span></td>
              </tr>
              <%}%>
              <tr>
                <td  class='title' width='67' align='center' >&nbsp;</td>
                <td  class='title' width='98' align='center' >&nbsp;</td>
                <td  class='title' width='114' align='center' >&nbsp;</td>
                <td  class='title' width='100' align='center' >&nbsp;</td>
                <td  class='title' width='93' align='center' >&nbsp;</td>
                <td  class='title' width='95' align='center' >&nbsp;</td>
                <td  class='title' width='94' align='center' >&nbsp;</td>
                <td align='center'  class='title' >&nbsp;</td>
              </tr>
            </table>
		</td>
	</tr>
<%}else{%>
	<tr>
	        
          <td class='line' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width="444" >
              <tr> 
                <td width="444" align='center'></td>
              </tr>
            </table></td>
	<td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width="905" >
          <tr> 
                <td width="100%"  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 업체가 없읍니다.</td>
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
