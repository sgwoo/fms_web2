<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchs(); //영업소 리스트 조회
	int brch_size = branches.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="tax_hap_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	

	//디스플레이 타입
	function cng_input(){	
		var fm = document.form1;
		var gubun3 = fm.gubun3.options[fm.gubun3.selectedIndex].value;
		if(gubun3 == '')                                        fm.gubun2[1].selected = true;
		if(gubun3 == '01' || gubun3 == '02' || gubun3 == '03')  fm.gubun2[1].selected = true;
		if(gubun3 == '04' || gubun3 == '05' || gubun3 == '06')  fm.gubun2[2].selected = true;
		if(gubun3 == '07' || gubun3 == '08' || gubun3 == '09')  fm.gubun2[3].selected = true;
		if(gubun3 == '10' || gubun3 == '11' || gubun3 == '12')  fm.gubun2[4].selected = true;
  }
	function list_print(cnt){
		fm = document.form1;
		fm.print_st.value = cnt;
		window.open("about:blank",'list_print','scrollbars=yes,status=no,resizable=yes,width=670,height=600,left=50,top=50');		
		fm.target = "list_print";		
		fm.action = "tax_hap_print.jsp";			
		fm.submit();
	}
	function list_excel(){
		fm = document.form1;
		var fm = document.form1;
		fm.action="tax_hap_excel.jsp";
		fm.target="_blank";		
		fm.submit();
	}
  
  
//-->
</script>

</head>
<body>
<form action="./tax_hap_sc.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="print_st" value="">  
<table border=0 cellspacing=0 cellpadding=0 width=100%>

	<tr>
		<td colspan=5>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서 > <span class=style5>
						세금계산서합계표</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>             
    <tr> 
      <td width="29%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" align=absmiddle>&nbsp; 
        <select name="gubun1" >
          <% for(int i=2002; i<=AddUtil.getDate2(1); i++){%>
          <option value="<%=i%>" <%if(i == AddUtil.parseInt(gubun1)){%> selected <%}%>><%=i%>년도</option>
          <%}%>
        </select>	
        <select name="gubun2">
          <option value="" <%if(gubun2.equals("")){%> selected <%}%>>전체</option>
          <option value="1" <%if(gubun2.equals("1")){%> selected <%}%>>1분기</option>
          <option value="2" <%if(gubun2.equals("2")){%> selected <%}%>>2분기</option>
          <option value="3" <%if(gubun2.equals("3")){%> selected <%}%>>3분기</option>
          <option value="4" <%if(gubun2.equals("4")){%> selected <%}%>>4분기</option>
        </select>	
        <select name="gubun3" onChange='javascript:cng_input()'>
          <option value="" <%if(gubun3.equals("")){%> selected <%}%>>전체</option>        
          <% for(int i=1; i<=12; i++){%>        
          <option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(gubun3)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
          <%}%>
        </select>
      </td>
      <td width="18%"><img src="/acar/images/center/arrow_mcyus.gif" align=absmiddle>&nbsp; 
	  	 
        <select name='s_br' onChange='javascript:Search();'>
          <option value=''>전체</option>
          <%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> <%= branch.get("BR_NM")%> </option>
          <%							}
						}		%>
        </select>
		   	
		    &nbsp;&nbsp;&nbsp; </td>
      <td width="16%"><img src="/acar/images/center/arrow_g.gif" align=absmiddle>&nbsp; 
        <select name='gubun4'>
          <option value=''  <%if(gubun4.equals("")){%>selected<%}%>>전체</option>
          <option value='1' <%if(gubun4.equals("1")){%>selected<%}%>>전자세금계산서</option>
          <option value='2' <%if(gubun4.equals("2")){%>selected<%}%>>우편발송</option>		  		  
          <option value='3' <%if(gubun4.equals("3")){%>selected<%}%>>건별</option>		  		  		  
        </select>
        </td>
      <td width=10%><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
      <td align=right>
    	  <a href="javascript:list_print(1)"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>
    	  <a href="javascript:list_print(2)">.</a>    	  
    	  <a href="javascript:list_excel()"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
