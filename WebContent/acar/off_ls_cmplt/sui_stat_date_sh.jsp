<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//제조사
	Vector vt = olcD.getSuiAbNm("1", "");
	int vt_size = vt.size();
	
	//차명
	Vector vt2 = olcD.getSuiAbNm("2", "");
	int vt_size2 = vt2.size();
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//검색
	function Search()
	{
		var fm = document.form1;
		fm.target = "c_foot";		
		fm.action = 'sui_stat_date_sc.jsp';			
		fm.submit();
	}	
	
	//자동차회사 선택시 차종코드 출력하기
	function GetCarNm(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.gubun3;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.gubun3";
		fm2.car_comp_id.value = fm.gubun2.options[fm.gubun2.selectedIndex].value;
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
}	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin=15>
<form action="./car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="mode" value="">  
</form>
<form name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>현황 및 통계 > 매각관리 > <span class=style5>매각차량잔가손익현황Ⅱ</span></span></td>
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
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						<select name="s_yy">
							<option value="" <%if(s_yy.equals("")){%>selected<%}%>>전체</option>						
			  			<%for(int i=2013; i<=AddUtil.getDate2(1); i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
	        			&nbsp;			        			
	        			차종 :  
				<select name="gubun1">
					<option value=""   <% if(gubun1.equals(""))   out.print("selected"); %>>전체</option>
					<option value="8"  <% if(gubun1.equals("8"))  out.print("selected"); %>>소형승용(LPG)</option>
					<option value="5"  <% if(gubun1.equals("5"))  out.print("selected"); %>>중형승용(LPG)</option>
					<option value="4"  <% if(gubun1.equals("4"))  out.print("selected"); %>>대형승용(LPG)</option>
					<option value="9"  <% if(gubun1.equals("9"))  out.print("selected"); %>>경승용</option>
					<option value="3"  <% if(gubun1.equals("3"))  out.print("selected"); %>>소형승용</option>
					<option value="2"  <% if(gubun1.equals("2"))  out.print("selected"); %>>중형승용</option>
					<option value="1"  <% if(gubun1.equals("1"))  out.print("selected"); %>>대형승용</option>
					<option value="6"  <% if(gubun1.equals("6"))  out.print("selected"); %>>RV</option>
					<option value="10" <% if(gubun1.equals("10")) out.print("selected"); %>>승합</option>
					<option value="7"  <% if(gubun1.equals("7"))  out.print("selected"); %>>화물</option>
					<option value="20" <% if(gubun1.equals("20")) out.print("selected"); %>>수입차</option>
				</select>
				&nbsp;		
				제조사 : 
				<select name="gubun2" id="gubun2" onChange="javascript:GetCarNm()">
				<option value=""   <% if(gubun2.equals(""))   out.print("selected"); %>>전체</option>
                <%	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);							
    			%>
                <option value="<%=ht.get("CAR_COMP_ID")%>" <% if(String.valueOf(ht.get("CAR_COMP_ID")).equals(gubun2)) out.print("selected"); %>><%=ht.get("NM")%></option>
                <%	}	%>
              </select>
              &nbsp;		
				차명 : 
				<select name="gubun3" id="gubun3">
				<option value=""   <% if(gubun2.equals(""))   out.print("selected"); %>>전체</option>
                <%	for(int i = 0 ; i < vt_size2 ; i++){
									Hashtable ht = (Hashtable)vt2.elementAt(i);							
    			%>
                <option value="<%=ht.get("AB_NM")%>" <% if(String.valueOf(ht.get("AB_NM")).equals(gubun3)) out.print("selected"); %>><%=ht.get("AB_NM")%></option>
                <%	}	%>
              </select>
              &nbsp;		
				구분 : 
				<select name="gubun4" id="gubun4">
					<option value=""   <% if(gubun4.equals(""))   out.print("selected"); %>>전체</option>
					<option value="경매"  <% if(gubun4.equals("경매"))  out.print("selected"); %>>경매</option>
					<option value="매입옵션"  <% if(gubun4.equals("매입옵션"))  out.print("selected"); %>>매입옵션</option>
              </select>
              
              &nbsp;	
              
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>						  
					</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>