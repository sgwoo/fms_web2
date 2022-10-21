<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function GetInsCom(serial_no, model, gubun, remark){
		var fm = parent.c_foot.document.form1;
		
		fm.serial_no.value = serial_no;	
		fm.model.value = model;
		fm.gubun.value = gubun;
		fm.remark.value = remark;
		fm.cmd.value = "u";		
		
		fm.serial_no.readOnly = true;
		
	}
	
	function NaviReg(serial_no, model, gubun){

	var url ="serial_no=" + serial_no 
			+ "&model=" + model
			+ "&gubun=" + gubun;

	
	var SUBWIN="./lc_navi_car_i.jsp?" + url;	//원본
	window.open(SUBWIN, "NaviReg", "left=100, top=100, width=1000, height=150, scrollbars=yes, status=yes");	
}

//-->
</script>

</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector inss = c_db.getNaviStatList();
	int ins_size = inss.size();
%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 월렌트관리  > <span class=style5>네비게이션 관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>       
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>					
                    <td class='line' width="100%"> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                              <td class=title width=5%>연번</td>
                                <td class=title width=15%>S / N</td>
                                <td class=title width=15%>모델명</td>
								<td class=title width=15%>네비장착 차량번호</td>
                                <td class=title width=10%>상태</td>
                                <td class=title width=45%>특이사항</td>                       
                            </tr>
                  <%if(ins_size > 0){
    					for(int i = 0 ; i < ins_size ; i++){
    						Hashtable ins = (Hashtable)inss.elementAt(i);%>
                            <tr> 
                              	<td align="center"><%= i+1%></td>
                                <td align="center"><a href="javascript:GetInsCom('<%=ins.get("SERIAL_NO")%>','<%=ins.get("MODEL")%>','<%=ins.get("GUBUN")%>','<%=ins.get("REMARK")%>')" onMouseOver="window.status=''; return true"><%=ins.get("SERIAL_NO")%></a></td>
                                <td align="center"><%=ins.get("MODEL")%></td>
								<td align="center"><%  if ( ins.get("GUBUN").equals("")||ins.get("GUBUN").equals("R") ) {%>
								<a href="javascript:NaviReg('<%=ins.get("SERIAL_NO")%>','<%=ins.get("MODEL")%>','N')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
								<%}else{%>
								
								<%}%>
								</td>
                                <td align="center">
                                <%  if ( ins.get("GUBUN").equals("N") ) {%>
                                  대여중
                                  <%} else if ( ins.get("GUBUN").equals("R") ) {%>
                                  예약중
                                  <%} else if ( ins.get("GUBUN").equals("M") ) {%>
                                  수리중
                                  <% } else { %>
                                  - 
                                  <% } %>
                                </td>
                                <td align="center"><%=ins.get("REMARK")%></td>
                                                       
                            </tr>
                  <%	}
    				}else{%>
                            <tr align="center"> 
                                <td colspan="10">등록된 자료가 없습니다.</td>
                            </tr>
                  <%}%>
                        </table>
    		        </td>    		
    		    </tr>
    	    </table>
	    </td>
    </tr>	
</table>
</body>
</html>