<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동전표 삭제관리 페이지
	
	String write_date 	= request.getParameter("write_date")==null?AddUtil.getDate():request.getParameter("write_date");
	String data_no 		= request.getParameter("data_no")==null?"":request.getParameter("data_no");
	String data_gubun 	= request.getParameter("data_gubun")==null?"":request.getParameter("data_gubun");
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	Vector vt = new Vector();
	
	if(!write_date.equals("")){
		vt = neoe_db.getAutodocuPayList(write_date, data_no, data_gubun);	//-> neoe_db 변환
	}
	
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//조회하기
	function search(){
		fm = document.form1;
		if(fm.write_date.value == ""){		alert("처리일자을 입력하십시오");		fm.write_date.focus();		return;		}
		fm.action = "autodocu_list.jsp";
		fm.target = "d_content";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//수정하기
	function autodoc_update(write_date, data_no, data_gubun, taxrela){
		fm = document.form1;
		fm.d_write_date.value 	= write_date;
		fm.d_data_no.value 		= data_no;
		fm.d_data_gubun.value 	= data_gubun;
		fm.d_taxrela.value 		= taxrela;								
		if(!confirm("수정하시겠습니까?"))		return;
		fm.action = "autodocu_u.jsp";
		fm.target = "_blank";
//		fm.submit();
	}	
//-->
</script>
</head>

<body onLoad="javascript:document.form1.write_date.focus()">
<form name='form1' action='' method='post'>
<input type='hidden' name="d_write_date" value="">
<input type='hidden' name="d_data_no" value="">
<input type='hidden' name="d_data_gubun" value="">
<input type='hidden' name="d_taxrela" value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>자동전표조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td>
            <table width="100%" border="0" cellpadding="0">
                <tr>
                    <td width="170">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_clij.gif align=absmiddle>&nbsp;
                      <input type='text' name='write_date' size='11' class='text' value='<%=write_date%>' onKeyDown='javascript:enter()'></td>
                    <td width="80"><img src=../images/center/arrow_bh.gif align=absmiddle>&nbsp;
                      <input type='text' name='data_no' size='3' class='text' value='<%=data_no%>' onKeyDown='javascript:enter()'></td>
                    <td width="120"><img src=../images/center/arrow_g.gif align=absmiddle>&nbsp;
                      <select name='data_gubun'>
        							<option value=''   <%if(data_gubun.equals("")){%> selected <%}%>> 선택 </option>
        							<option value='21' <%if(data_gubun.equals("21")){%> selected <%}%>> 국내매출 </option>
        							<option value='51' <%if(data_gubun.equals("51")){%> selected <%}%>> 국내구매 </option>
        							<option value='53' <%if(data_gubun.equals("53")){%> selected <%}%>> 기타 </option>							
									<option value='54' <%if(data_gubun.equals("54")){%> selected <%}%>> 지급 </option>							
        			  </select></td>
                    <td><a href='javascript:search()'><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>
                </tr>
            </table> 
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width=5%>연번</td>
                    <td class="title" width=10%>처리일자</td>
                    <td class="title" width=5%>번호</td>
                    <td class="title" width=10%>구분</td>
                    <td class="title" width=50%>적요</td>
                    <td class="title" width=10%>처리여부</td>					
                    <td class="title" width=10%>비고</td>			  
                </tr>
            <% 	if(vt_size>0){ 
					for(int i=0;i < vt_size;i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr>
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(ht.get("WRITE_DATE"))) %></td>
                    <td align="center"><%= ht.get("DATA_NO") %></td>
                    <td align="center"><%= ht.get("GUBUN") %></td>
                    <td align="center"><%= ht.get("CONT") %></td>
                    <td align="center"><%= ht.get("STAT_NM") %></td>					
                    <td align="center">
			        <a href="javascript:autodoc_update('<%= ht.get("WRITE_DATE") %>','<%= ht.get("DATA_NO") %>','<%= ht.get("DATA_GUBUN") %>','<%= ht.get("TAXRELA") %>');"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a>
			        </td>
                </tr>
            <% 		}
		  		}else{ %>
                <tr>
                    <td colspan="7" class=""><div align="center">해당 자동전표가 없습니다.</div></td>
                </tr>
            <% 	} %>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
