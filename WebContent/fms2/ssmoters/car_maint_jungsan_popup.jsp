<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.master_car.*, acar.util.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String m1_no = request.getParameter("m1_no")==null?"":request.getParameter("m1_no");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	

	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
		
	//정비정보
	CarMaintReqBean  s_bean = mc_db.getCarMaintInfo(m1_no, rent_l_cd );	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='JavaScript'>
<!--
	//저장하기
	function save(){
		var fm = document.form1;
		
		if ( fm.use_yn[0].checked ==true || fm.use_yn[1].checked ==true  || fm.use_yn[2].checked ==true  ) {
		} else {
			 alert('진행여부를 체크하십시오'); 	return;	
		}
			
		if (fm.use_yn[0].checked ==true ) {		
			if(fm.che_dt.value == '')				{ alert('검사일을 입력하십시오'); 		fm.che_dt.focus(); 		return;	}
			if(fm.che_nm.value == '')				{ alert('검사소를 입력하십시오'); 		fm.che_nm.focus(); 		return;	}
			if( toInt(parseDigit(fm.tot_dist.value)) < 1 ) { 	 alert('주행거리를 입력하십시오'); 		fm.tot_dist.focus(); 		return;	}	
			if(fm.che_type.value == '')				{ alert('검사종류를 입력하십시오'); 		fm.che_type.focus(); 		return;	}
			if( toInt(parseDigit(fm.che_amt.value)) < 1 ) { 	 alert('검사금액을 입력하십시오'); 		fm.che_amt.focus(); 		return;	}	
		}		
		
		if ( fm.use_yn[1].checked ==true ) {
		  if (fm.user_id.value == '000140' || fm.user_id.value == '000254' ||  fm.user_id.value == '000063' ||  fm.user_id.value == '000332' ||  fm.user_id.value == '000198') {
		  
		  } else {
		   if (fm.user_id.value != fm.mng_id.value ) {
		   		alert('차량 관리담당자만 취소할 수 있습니다.!!!'); 	return;	
		   }		  
		  }
		
		} 
							
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'car_maint_jungsan_popup_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
	//저장하기
	function dele(){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){	return;	}
		fm.action = 'car_maint_jungsan_popup_a.jsp?cmd=D';
		fm.target = 'i_no';
		fm.submit();			
	}
//-->
</script>
</head>
<body leftmargin="15" >
<form action="" name="form1" method="post" >

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="car_mng_id" value="<%=s_bean.getCar_mng_id()%>" >
<input type="hidden" name="rent_l_cd" value="<%=s_bean.getRent_l_cd()%>" >
<input type="hidden" name="m1_no" value="<%=s_bean.getM1_no()%>" >
<input type="hidden" name="mng_id" value="<%=s_bean.getMng_id()%>" >

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>자동차 검사 > <span class=style5>검사 수정 </span></span></td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
             	<tr> 
                    <td class=title width="80">차량번호</td>
                    <td> 
                      <input type="text" name="car_no" value="<%=AddUtil.ChangeDate2(s_bean.getCar_no())%>" size="20" class=text readonly  >
                    </td>
                </tr>
                <tr> 
                    <td class=title width="80">의뢰일</td>
                    <td> 
                      <input type="text" name="m1_dt" value="<%=AddUtil.ChangeDate2(s_bean.getM1_dt())%>" size="11" class=text readonly  >
                    </td>
                </tr>
                <tr> 
                    <td class=title width="80">의뢰자</td>
                    <td> 
                      <input type="text" name="user_nm" value="<%=s_bean.getMng_nm()%>" size="14" class=text readonly  >
                    </td>
                </tr>
                <tr> 
                    <td class=title width="80">요구사항</td>
                    <td> 
                      <textarea name="m1_content" cols="50" class="text" rows="4"><%=s_bean.getM1_content()%></textarea>
                 
                    </td>
                </tr>
                 <tr> 
                    <td class=title width="80"> 차령연장 <br>임시검사</td>
                    <td> 
                         <input type="text" name="gubun"  value="<%=s_bean.getGubun()%>" size="2" class=text readonly  >
                 
                    </td>
                </tr>
                
                <tr> 
                    <td class=title width="80">검사진행</td>
                    <td> 
                       <input type="radio" name="use_yn" value="Y" <% if(s_bean.getUse_yn().equals("Y")) out.print("checked"); %> >
            			진행            		   
            		   <input type="radio" name="use_yn" value="N" <% if(s_bean.getUse_yn().equals("N")) out.print("checked"); %> >
            			취소            		
            		   <input type="radio" name="use_yn" value="X" <% if(s_bean.getUse_yn().equals("X")) out.print("checked"); %> >
            			기타  	           			
                      
                    </td>
                </tr>
                
                <tr> 
                    <td class=title width="80">검사일</td>
                    <td> 
                      <input type="text" name="che_dt" value="<%=AddUtil.ChangeDate2(s_bean.getChe_dt())%>" size="11" class=text  onBlur='javascript: this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class=title width="80">검사소</td>
                    <td> 
                      <input type="text" name="che_nm" value="<%=s_bean.getChe_nm()%>" size="20" class=text  >
                    </td>
                </tr>
                
                <tr> 
                    <td class=title width="80">주행거리</td>
                    <td> 
                      <input type="text" name="tot_dist" value="<%=AddUtil.parseDecimal(s_bean.getTot_dist())%>" size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value);' >
                     
                    </td>
                </tr>
                
                <tr> 
                    <td class=title width="80">검사종류</td>
                    <td> 
                      <input type="text" name="che_type" value="<%=s_bean.getChe_type()%>" size="20" class=text >
                    </td>
                </tr>
                
                <tr> 
                    <td class=title width="80">금액</td>
                    <td> 
                      <input type="text" name="che_amt" value="<%=AddUtil.parseDecimal(s_bean.getChe_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);' >
                    </td>
                </tr>
                
                <tr> 
                    <td class=title width="80">특이사항</td>
                    <td> 
                      <textarea name="che_remark" cols="50" class="text" rows="8"><%=s_bean.getChe_remark()%></textarea>
                 
                    </td>
                </tr>
                
                                
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
      <% if ( s_bean.getJung_dt().equals("") &&  auth_rw.equals("6") ) {%>  
        <a href="javascript:save();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a> 
      <% } %>       
        <a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        &nbsp;&nbsp;
         <% if (user_id.equals("000063") && ( s_bean.getOff_id().equals("000286") ) ) {%> <!--  excel로 등록한 업체만 가능  정일현대 -->
      <a href="javascript:dele();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
     <% }  %>
                
        </td>
    </tr>
</table>  

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
