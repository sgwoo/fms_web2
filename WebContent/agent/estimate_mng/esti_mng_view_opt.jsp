<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
  String auth_rw  = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
  String br_id    = request.getParameter("br_id")==null?"":request.getParameter("br_id");
  String user_id  = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");

  String car_comp_id   = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
  String code   = request.getParameter("code")==null?"":request.getParameter("code");
  String car_id	   = request.getParameter("car_id")==null?"":request.getParameter("car_id");
  String car_seq	   = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
  
  AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
  
  //Vector baseList = a_cmb.getCarBaseList(car_comp_id, code, car_id);
  Vector baseList = a_cmb.getCarBaseList2(car_comp_id, code, car_id, car_seq);
  int baseList_size = baseList.size();
  
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style type="text/css">
.cont{padding:10px;}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">  

</script>
</head>
<body onload="javascript:document.form1.est_nm.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td colspan=2>
          <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5> 차량 사양보기</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
      </td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량 사양보기</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
<%if(baseList_size>0){ %> 
	<%for(int i=0; i<baseList_size; i++){ %>
	<%-- <%for(int i=0; i<1; i++){ %> --%>
		<%Hashtable base = (Hashtable)baseList.elementAt(i); %>
		<%if(i==0){ %>
				<tr>
					<td class=title width=10%>제조사</td>
					<td class=cont width=40% colspan="3"><%=base.get("CAR_COMP_NM")%></td>
					<td class=title width=10%>차명</td>
					<td class=cont width=40% colspan="3"><%=base.get("CAR_NM")%></td>
				</tr>
		<%} %>			
                <tr>
                    <td class=title>차종</td>
                    <td class=cont colspan="3"><%=base.get("CAR_NAME")%></td>
                    <td class=title>가격</td>
                    <td class=cont colspan="3"><%=AddUtil.parseDecimal(base.get("CAR_B_P"))%>원</td>
                </tr>  
                <tr>
                	<td class=title colspan="5">기본사양</td>
                    <td class=title colspan="3">선택사양</td>
                </tr>
                <tr>
                	<td class=cont colspan="5" style="vertical-align: top; padding-top: 15px;">
                		<%if(!base.get("CAR_B_INC_ID").equals("")){ 
                			Hashtable upperTrim = a_cmb.getUpperTrim((String)base.get("CAR_B_INC_ID"), (String)base.get("CAR_B_INC_SEQ"));	
                		%>
                			<b><%=upperTrim.get("CAR_NAME") %> 기본사양 외</b>
                		<%} %>
                		<pre style="white-space: pre-line; word-wrap:break;">
                			<%=base.get("CAR_B")%>
                		</pre>
                	</td>
                    <td class=cont colspan="3" style="vertical-align: top;">
                    	<table border="0">
        <%	
        	//Vector optionList = a_cmb.getCarOptionList(car_comp_id, code, (String)base.get("CAR_ID"));  
        	Vector optionList = a_cmb.getCarOptionList2(car_comp_id, code, (String)base.get("CAR_ID"), car_seq);  
        	int optionList_size = optionList.size(); 
        	if(optionList_size>0){
        		for(int j=0; j<optionList_size; j++){
        			Hashtable option = (Hashtable)optionList.elementAt(j);
        	%>
                    		<tr>
                    			<td width="270px;">· <%=option.get("NM") %></td>
                    			<td align="right" style="vertical-align: top; padding-left: 10px;">(<%=AddUtil.parseDecimal(option.get("AMT")) %>원)</td>
        					<tr>
        <%		}
        	}
        	%>            
        				</table>
                    </td>
                </tr>
                <tr>
			        <td class=line2 colspan=2></td>
			    </tr>
	<%} %>
<%}else{ %>
				<tr>
					<td align="center">데이터가 존재하지 않습니다. (제조사, 차명, 차종을 다시 확인해주세요)</td>
				</tr>
<%} %>
            </table>          
        </td>
    </tr>          
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>