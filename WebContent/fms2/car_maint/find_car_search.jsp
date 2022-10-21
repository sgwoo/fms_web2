<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");  //메이커
	String code = request.getParameter("code")==null?"":request.getParameter("code");  //차종(차명)
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	
	CarOfficeDatabase umd 	= CarOfficeDatabase.getInstance();
		
	CarCompBean cc_r [] = umd.getCarCompAllNew("1");
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	
	//의뢰 선택
	function confirm(){
		var fm1= document.form1;	
		var fm = i_no.document.form1;		
		var len=fm.elements.length;			
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "cho_id"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("차량을 선택하세요.");
			return;
		}	
							
		fm.target = "c_foot";
		fm.action = "recall_doc_reg_sc.jsp" ;		
		fm.submit();
		window.close();
	}	
	
	
		//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		fm2.mode.value = '1';
		fm2.t_wd.value = "";			
		fm2.target="ii_no";
		fm2.submit();
	}
	
		//자동차회사 선택시 차종코드 출력하기
	function GetCarCode1(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		fm2.code.value = <%=code%>;				
		fm2.mode.value = '1';
		fm2.t_wd.value = "X";		
		fm2.target="ii_no";
		fm2.submit();
		
	}
			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body onload="javascript:GetCarCode1();" leftmargin=15>
<form action="get_car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_origin" value="">
  <input type="hidden" name="car_comp_id" value="">  
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">    
  <input type="hidden" name="t_wd" value="">      
  <input type="hidden" name="auth_rw" value="">
  <input type="hidden" name="mode" value="">
</form>

<form name='form1' action='find_car_search_in.jsp' method='post' target='i_no'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=930>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>차량 조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;                     
                    	  <select name="car_comp_id" onChange="javascript:GetCarCode()">
                    	   <option value="">선택</option>
            					  
		                <%	for(int i=0; i<cc_r.length; i++){
								cc_bean = cc_r[i];
								if(cc_bean.getNm().equals("에이전트")) continue;%>
		                <option value="<%= cc_bean.getCode() %>" <% if(cc_bean.getCode().equals(car_comp_id)) out.print("selected"); %>><%= cc_bean.getNm() %></option>
		                <%	}	%>
		              </select> 
             
        		</td>
        		  <td> &nbsp;  
                 			<select name="code" >
                                	  <option value="">선택</option>      
                                
                              	</select>            
                     </td>
                </tr>     
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      당월 
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      조회기간 </td> 
                    <td> 
                      <select name="gubun2">
                 <!--       <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>계약일</option> -->
                        <option value="1" <%if(gubun2.equals("2"))%>selected<%%>>출고일</option>
                      
                      </select>&nbsp;			
                      <input type="text" name="st_dt" value='<%=st_dt%>' size="9" class="text">
                      ~ 
                      <input type="text" name="end_dt" value='<%=end_dt%>' size="9" class="text">
                    </td>
                    <td colspan=2 >     
                      <a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./find_car_search_in.jsp?car_comp_id=<%=car_comp_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&code=<%=code%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&t_wd=<%=t_wd%>" name="i_no" width="920" height="530" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr>
        <td style='height:5'></td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:confirm()"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="ii_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
