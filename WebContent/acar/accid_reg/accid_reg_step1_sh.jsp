<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "22", "01");	
	
			
	String s_gubun1 = request.getParameter("s_gubun1")==null?"8":request.getParameter("s_gubun1");//사고형태
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");//검색조건
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");//검색어
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	int our_p = 0;
	int ot_p = 0;
	
	if(s_gubun1.equals("1"))		ot_p = 100;
	else if(s_gubun1.equals("2"))	our_p = 100;
	else if(s_gubun1.equals("8"))	our_p = 100;
	else if(s_gubun1.equals("6"))	our_p = 100;
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
				
	String display = "";
	String cons_cau = "";
	String cost_st = "1";
	String pay_st = "2";
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//하단 디스플레이
	function cng_display(){
		var fm1 = document.form1;		
		
		if(fm1.s_gubun1.options[fm1.s_gubun1.selectedIndex].value == '1'){	
			fm1.our_fault_per.value = 0;
			fm1.ot_fault_per.value = 100;
			fm1.dam_type1.checked = false;
			fm1.dam_type2.checked = false;
			fm1.dam_type3.checked = true;
			fm1.dam_type4.checked = true;									
		}else if(fm1.s_gubun1.options[fm1.s_gubun1.selectedIndex].value == '2'){
	
			fm1.our_fault_per.value = 100;
			fm1.ot_fault_per.value = 0;
			fm1.dam_type1.checked = true;
			fm1.dam_type2.checked = true;
			fm1.dam_type3.checked = false;
			fm1.dam_type4.checked = false;			
		}else if(fm1.s_gubun1.options[fm1.s_gubun1.selectedIndex].value == '3'){
		
			fm1.our_fault_per.value = 0;
			fm1.ot_fault_per.value = 0;		
			fm1.dam_type1.checked = true;
			fm1.dam_type2.checked = true;
			fm1.dam_type3.checked = true;
			fm1.dam_type4.checked = true;							
		}else if(fm1.s_gubun1.options[fm1.s_gubun1.selectedIndex].value == '4' || fm1.s_gubun1.options[fm1.s_gubun1.selectedIndex].value == '7'){
		
			fm1.our_fault_per.value = 0;
			fm1.ot_fault_per.value = 0;	
			fm1.dam_type1.checked = false;
			fm1.dam_type2.checked = false;
			fm1.dam_type3.checked = true;
			fm1.dam_type4.checked = true;													
		}else if(fm1.s_gubun1.options[fm1.s_gubun1.selectedIndex].value == '5' || fm1.s_gubun1.options[fm1.s_gubun1.selectedIndex].value == '6'){
	
			fm1.our_fault_per.value = 0;
			fm1.ot_fault_per.value = 0;				
			fm1.dam_type1.checked = false;
			fm1.dam_type2.checked = false;
			fm1.dam_type3.checked = true;
			fm1.dam_type4.checked = true;													
		}
	}	
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
		
//계약검색하기
	function find_cont_search(){
		var fm = document.form1;
	
		window.open("find_cont_search.jsp?gubun=rent_dt&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>", "SEARCH_FINE", "left=50, top=50, width=980, height=700, scrollbars=no");
	}		
			
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">

<form name='form1' action='accid_reg_step1_sc.jsp' target='c_foot' method='post'>

 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 사고관리 > <span class=style5> 사고(양수차량)의뢰등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
    		      		 <td class=title width=9%>접수일자</td>
                    <td width=30%> 
                      <input type="text" name="reg_dt" value="<%=AddUtil.getDate()%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=9%>접수자</td>
                    <td width=52%> 
                      <select name='reg_id'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
    	        </tr>				
    		    <tr>
    		         <td class=title>사고유형</td>
                   <td >
	    		       <select name='s_gubun1' onChange='javascript:cng_display()'>
				          <option value=""> ===선택=== </option>
				          <option value="1" <%if(s_gubun1.equals("1"))%>selected<%%>>피해</option>
				          <option value="2" <%if(s_gubun1.equals("2"))%>selected<%%>>가해</option>
				          <option value="3" <%if(s_gubun1.equals("3"))%>selected<%%>>쌍방</option>
				   <!--       <option value="5" <%if(s_gubun1.equals("5"))%>selected<%%>>사고자차</option>
				          <option value="4" <%if(s_gubun1.equals("4"))%>selected<%%>>운행자차</option>      
				          <option value="7" <%if(s_gubun1.equals("7"))%>selected<%%>>재리스정비</option>		-->  
				           <option value="8" <%if(s_gubun1.equals("8"))%>selected<%%>>단독</option>		  
				          <option value="6" <%if(s_gubun1.equals("6"))%>selected<%%>>수해</option>
				         
				        </select>
				        </td>        
                    <td class=title>사고구분</td>
                    <td>
                      <input type="checkbox" name="dam_type1" value="Y"  <%if(s_gubun1.equals("2") || s_gubun1.equals("3"))%>checked<%%>>
                      대인 
                      <input type="checkbox" name="dam_type2" value="Y"  <%if(s_gubun1.equals("2") || s_gubun1.equals("3"))%>checked<%%>>
                      대물 
                      <input type="checkbox" name="dam_type3" value="Y"  <%if(!s_gubun1.equals("3"))%>checked<%%>>
                      자손 
                      <input type="checkbox" name="dam_type4" value="Y"  <%if(!s_gubun1.equals("3"))%>checked<%%>>
                      자차</td>
                </tr>
                <tr> 
                    <td class=title>특이사항</td>
                    <td colspan="3"> 
                      <textarea name="sub_etc" cols="105" class="text" rows="2">자산양수차량 정비</textarea>
                    </td>
                </tr>
    	       
    	         <tr>
    		   		  <td colspan="4"> 
		            <table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr> 
		                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고개요</span></td>
		                </tr>
		                <tr>
		                    <td class=line2></td>
		                </tr>
		                <tr> 
		                    <td class=line> 
		                        <table border="0" cellspacing="1" width=100%>
		                            <tr> 
		                              <td class=title colspan="2">사고형태</td>
		                              <td width=30%> 
		                                <select name='accid_type'>
		                                  <option value="">선택</option>
		                                  <option value="1">차대차</option>
		                                  <option value="2">차대사람</option>
		                                  <option value="3">차량단독</option>
		                                  <option value="4">차대열차</option>
		                                </select>
		                              </td>
		                              <td class=title width=9%>사고일시</td>
		                              <td width="52%"> 
		                                <input type="text" name="accid_dt" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
		                                <input type="text" name="accid_dt_h" size="2" class=text maxlength="2">
		                                시 
		                                <input type="text" name="accid_dt_m" size="2" class=text maxlength="2">
		                                분 <font color="#808080">(시간:0-23)</font> </td>
		                            </tr>
		                            <tr> 
		                              <td class=title colspan="2">사고장소</td>
		                              <td colspan="3"> 
		                                <select name='accid_type_sub'>
		                                  <option value="">선택</option>
		                                  <option value="1">단일로</option>
		                                  <option value="2">교차로</option>
		                                  <option value="3">철길건널목</option>
		                                  <option value="4">커브길</option>
		                                  <option value="5">경사로</option>
		                                  <option value="6">주차장</option>
		                                  <option value="7">골목길</option>
		                                  <option value="8">기타</option>
		                                </select>
		                                <input type="text" name="accid_addr" class=text size="92">
		                              </td>
		                            </tr>
		                            <tr> 
		                              <td class=title width=3% rowspan="2">사고경위</td>
		                              <td class=title width=6% height="76">왜?</td>
		                              <td colspan="3" height="76"> 
		                                <textarea name="accid_cont" cols="105" rows="3"></textarea>
		                              </td>
		                            </tr>
		                            <tr> 
		                              <td class=title>어떻게?</td>
		                              <td colspan="3"> 
		                                <textarea name="accid_cont2" cols="105" rows="4"></textarea>
		                              </td>
		                            </tr>
		                            <tr> 
		                              <td class=title colspan="2">과실비율</td>
		                              <td>당사 
		                                <input type="text" name="our_fault_per" size="4" value="<%=our_p%>" class=num onBlur='javascript:document.form1.ot_fault_per.value=Math.abs(toInt(this.value)-100);'>
		                                : 
		                                <input type="text" name="ot_fault_per" size="4" value="<%=ot_p%>" class=num onBlur='javascript:document.form1.our_fault_per.value=Math.abs(toInt(this.value)-100);'>
		                                상대방 </td>
		                              <td class=title>중대과실여부</td>
		                              <td> 
		                                <select name="imp_fault_st">
		                                  <option value="">없음</option>
		                                  <option value="1">음주</option>
		                                  <option value="2">신호위반</option>
		                                  <option value="3">속도위반</option>
		                                  <option value="4">횡단보도</option>
		                                  <option value="5">중앙선침범</option>
		                                  <option value="6">사고후도주</option>
		                                  <option value="7">앞지르기위반</option>
		                                  <option value="8">철길</option>
		                                  <option value="9">인도</option>
		                                  <option value="10">기타</option>
		                                </select>
		                                <input type="text" name="imp_fault_sub" size="30" class=text>
		                              </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		            </table>
    	            </td>
    	        </tr>    
   
            </table>
        </td>
    </tr>
   
    <tr>
        <td class=h></td>
    </tr>		
	
	 <tr> 
        <td><a href="javascript:find_cont_search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>		
    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
var fm = document.form1;	
//-->
</script>
</body>
</html>