<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ma.*"%>
<jsp:useBean id="MaMenuDb" class="acar.ma.MaMenuDatabase" scope="page" />
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String colspan = request.getParameter("colspan")==null?"":request.getParameter("colspan");
	String print_yn = request.getParameter("print_yn")==null?"N":request.getParameter("print_yn");
	String reg_yn = request.getParameter("reg_yn")==null?"N":request.getParameter("reg_yn");
	String update_yn = request.getParameter("update_yn")==null?"N":request.getParameter("update_yn");
	String list_yn = request.getParameter("list_yn")==null?"N":request.getParameter("list_yn");
	String back_yn = request.getParameter("back_yn")==null?"N":request.getParameter("back_yn");
	String type = request.getParameter("type")==null?"":request.getParameter("type");
	String print_st = request.getParameter("print_st")==null?"":request.getParameter("print_st");
	String excel_yn = request.getParameter("excel_yn")==null?"N":request.getParameter("excel_yn");
	String menu = m_st+m_st2+m_cd;
	String id_value = request.getParameter("id_value")==null?"":request.getParameter("id_value");
//System.out.println("id_value="+id_value);	
%>
    <tr> 
      <td <%if(!colspan.equals("")){%>colspan='<%=Util.parseInt(colspan)-1%>'<%}%>><font color="#666600"><%=MaMenuDb.getMenuNm(m_st, "00", "00")%> > <%=MaMenuDb.getMenuNm(m_st, m_st2, "00")%> 
        ></font><font color="#A29E75">&nbsp; </font> <font color="#FF0000"><%=MaMenuDb.getMenuNm(m_st, m_st2, m_cd)%></font></td>           
	  <td align="right">
	    <%if(excel_yn.equals("Y")){%>
	    <input type="button" class="btn" name="b53254" value="Excel" onClick="javascript:parent.location.href=''">&nbsp; 
	    <%}%>	  
	    <%if(print_yn.equals("Y")){%>
	    <a href="javascript:PrintOpenBrWindow()"><img src="../../../images/content/printer.gif" width="21" height="17" border="0"></a>&nbsp; 
	    <%}%>
	    <%if(reg_yn.equals("Y")){%>
    	<a href="<%=self_location%>_i.jsp<%=hidden_value %>" target="d_content"><img src="../../../images/bbs/but_in.gif" width="50" height="18" border="0"></a>&nbsp;	
	    <%}%>
    	<%if(update_yn.equals("Y")){%>
	    <a href="<%=self_location%>_u<%=type%>.jsp<%=hidden_value %>&<%= id_value %>" target="d_content"><img src="../../../images/content/but_modi.gif" width="50" height="18" border="0"></a>&nbsp;	
    	<%}%>
	    <%if(back_yn.equals("Y")){%>
    	<a href="javascript:history.go(-1)" target="d_content"><img src="../../../images/bbs/but_backgo.gif" border="0" width="70" height="18"></a>&nbsp;	
	    <%}%>
    	<%if(list_yn.equals("Y")&& !menu.equals("010303")){%>
	    <a href="<%=self_location%>_frame.jsp<%=hidden_value %>" target="d_content"><img src="../../../images/bbs/but_list.gif" width="50" height="18" border="0"></a>&nbsp;	
    	<%}%>
	  </td>		
    </tr>
<%if(print_yn.equals("Y")){%>	
<script language='javascript'>
<!--
	//팝업윈도우 열기
	function PrintOpenBrWindow() { //v2.0
		theURL = "<%=self_location+print_st%>.jsp<%=hidden_value %>";
		window.open(theURL,'popwin_print','scrollbars=yes,status=yes,resizable=yes,width=700,height=600,left=50,top=50');
	}		
//-->
</script>
<%}%>	