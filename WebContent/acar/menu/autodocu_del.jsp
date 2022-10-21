<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동전표 삭제관리 페이지
	
	String write_date 	= request.getParameter("write_date")==null?"":request.getParameter("write_date");
	String data_no 		= request.getParameter("data_no")==null?"":request.getParameter("data_no");
	String data_gubun 	= request.getParameter("data_gubun")==null?"":request.getParameter("data_gubun");
	
	
	out.println("더존IU 자동전표체크리스트에서 삭제하세요.");
	if(1==1)return;
	
	Vector vt = new Vector();
	
	
	int vt_size = vt.size();
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
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
		fm.action = "autodocu_del.jsp";
		fm.target = "d_content";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//삭제하기
	function autodoc_delete(write_date, data_no, data_gubun, taxrela){
		fm = document.form1;
		fm.d_write_date.value 	= write_date;
		fm.d_data_no.value 		= data_no;
		fm.d_data_gubun.value 	= data_gubun;
		fm.d_taxrela.value 		= taxrela;								
		if(!confirm("삭제하시겠습니까?"))		return;
		fm.action = "autodocu_del_a.jsp";
		fm.target = "i_no";
		fm.submit();
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>자동전표삭제</span></span></td>
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
                    <td class="title" width=7%>연번</td>
                    <td class="title" width=13%>처리일자</td>
                    <td class="title" width=10%>번호</td>
                    <td class="title" width=13%>구분</td>
                    <td class="title" width=49%>적요</td>
                    <td class="title" width=8%>삭제</td>			  
                </tr>
            <% 	if(vt_size>0){ 
					for(int i=0;i < vt_size;i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(user_bean.getUser_nm().equals("계성진") && !user_bean.getId().equals(String.valueOf(ht.get("REG_ID")))){
							continue;
						}						
						
						count++;%>
                <tr>
                    <td align="center"><%= count %></td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(ht.get("WRITE_DATE"))) %></td>
                    <td align="center"><%= ht.get("DATA_NO") %></td>
                    <td align="center"><%= ht.get("GUBUN") %></td>
                    <td align="center"><%= ht.get("CONT") %></td>
                    <td align="center">
			        <a href="javascript:autodoc_delete('<%= ht.get("WRITE_DATE") %>','<%= ht.get("DATA_NO") %>','<%= ht.get("DATA_GUBUN") %>','<%= ht.get("TAXRELA") %>');"><img src=../images/center/button_in_delete.gif align=absmiddle border=0></a>
			        </td>
                </tr>
            <% 		}
		  		}else{ %>
                <tr>
                    <td colspan="6" class=""><div align="center">해당 자동전표가 없습니다.</div></td>
                </tr>
            <% 	} %>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td>* 미승인전표만 삭제 가능합니다.</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
