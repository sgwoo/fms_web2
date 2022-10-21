<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_register.*, acar.common.*" %>
<jsp:useBean id="cc_bean" class="acar.car_register.CarChaBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String rent_mng_id = "";
	String rent_l_cd = "";
	String car_mng_id = ""; 		//자동차관리번호
	int seq_no = 0;					//SEQ_NO
	String cha_item = "";			//점검종별
	String cha_st_dt = "";			//점검정비유효기간1
	String cha_end_dt = "";			//점검정비유효기간2
	String cha_nm = "";				//
	String cha_st = "";				//
	int cha_amt = 0;				//비용
	int cha_v_amt = 0;				//비용-부가세
	String cmd = "";
	int count = 0;
	
	if(request.getParameter("rent_mng_id") != null) rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") != null) 	rent_l_cd 	= request.getParameter("rent_l_cd");
	if(request.getParameter("car_mng_id") != null) 	car_mng_id 	= request.getParameter("car_mng_id");
	if(request.getParameter("cmd") != null) 		cmd 		= request.getParameter("cmd");
	if(request.getParameter("seq_no") != null) 		seq_no 		= Util.parseInt(request.getParameter("seq_no"));
	if(request.getParameter("cha_item") != null) 	cha_item 	= request.getParameter("cha_item");
	if(request.getParameter("cha_st_dt") != null) 	cha_st_dt 	= request.getParameter("cha_st_dt");
	if(request.getParameter("cha_end_dt") != null) 	cha_end_dt 	= request.getParameter("cha_end_dt");
	if(request.getParameter("cha_nm") != null) 		cha_nm 		= request.getParameter("cha_nm");
	if(request.getParameter("cha_st") != null) 		cha_st 		= request.getParameter("cha_st");
	if(request.getParameter("cha_amt") != null) 	cha_amt 	= AddUtil.parseDigit(request.getParameter("cha_amt"));
	if(request.getParameter("cha_v_amt") != null) 	cha_v_amt 	= AddUtil.parseDigit(request.getParameter("cha_v_amt"));
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
		cc_bean.setCar_mng_id(car_mng_id);
		cc_bean.setSeq_no(seq_no);					//SEQ_NO
		cc_bean.setCha_item(cha_item);				//점검종별
		cc_bean.setCha_st_dt(cha_st_dt);			//점검정비유효기간1
		cc_bean.setCha_end_dt(cha_end_dt);			//점검정비유효기간2
		cc_bean.setCha_nm(cha_nm);					//점검정비점검일자
		cc_bean.setCha_st(cha_st);					//구분
		cc_bean.setCha_amt(cha_amt);				//비용
		cc_bean.setCha_v_amt(cha_v_amt);			//비용-부가세
		
		if(cmd.equals("i"))
		{
			count = crd.insertCarCha(cc_bean);
		}else if(cmd.equals("u")){
			count = crd.updateCarCha(cc_bean);
		}
	}
	
	CarChaBean cc_r [] = crd.getCarChaAll(car_mng_id);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
function CarChaReg()
{
	var theForm = document.CarChaForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value = theForm1.car_mng_id.value;
	if(theForm.car_mng_id == "")
	{
		alert('상단화명을 등록후 등록하십시오');
		return;
	}
	if(theForm.seq_no.value!="")
	{
		alert("수정만이 가능합니다.");
		return;
	}
	if(theForm.cha_st.value=="")
	{
		alert("구분을 선택하십시오.");
		return;
	}
	if(theForm.cha_st.value=="4")
	{
		alert("계기판교환은 이화면에서 등록할 수 없습니다.");
		return;
	}

	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	theForm.cmd.value = "i";
	theForm.submit();
}
function CarChaUp()
{
	var theForm = document.CarChaForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value = theForm1.car_mng_id.value;
	if(theForm.car_mng_id == "")
	{
		alert('상단화명을 등록후 등록하십시오');
		return;
	}
	if(theForm.seq_no.value=="")
	{
		alert("등록만이 가능합니다.");
		return;
	}
	
	if(theForm.cha_st.value=="4")
	{
		alert("계기판교환은 이화면에서 수정할 수 없습니다.");
		return;
	}
	
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
	
	theForm.cmd.value = "u";
	theForm.submit();
}
function ChangeDT( arg )
{
	var theForm = document.CarChaForm;
	if(arg=="st_dt")
	{
		theForm.cha_st_dt.value = ChangeDate(theForm.cha_st_dt.value);
	}else if(arg=="end_dt"){
		theForm.cha_end_dt.value = ChangeDate(theForm.cha_end_dt.value);
	}
}
function ChaUp(seq_no,cha_item,cha_st_dt,cha_end_dt,cha_nm,cha_st)
{
	var theForm = document.CarChaForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value 	= theForm1.car_mng_id.value;
	theForm.seq_no.value 		= seq_no;
	theForm.cha_item.value 		= cha_item;
	theForm.cha_st_dt.value 	= cha_st_dt;
//	theForm.cha_end_dt.value 	= cha_end_dt;
	theForm.cha_nm.value 		= cha_nm;
//	theForm.cha_amt.value 		= cha_amt;	
//	theForm.cha_v_amt.value 	= cha_v_amt;		
	if(cha_st == '1') theForm.cha_st[1].selected = true;
	if(cha_st == '2') theForm.cha_st[2].selected = true;
	if(cha_st == '3') theForm.cha_st[3].selected = true;		
	if(cha_st == '4') theForm.cha_st[4].selected = true;		
}
//-->
</script>
</head>
<body leftmargin="15">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="./register_change_id.jsp" name="CarChaForm" method="POST" >   
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>구조/장치변경</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100% cellpadding=0>
<%
	if(cmd.equals("ud"))
	{
%>
               	<tr>
                    <td  class=title>구분</td>
                    <td  class=title>내용</td>
                    <td  class=title>시행일자</td>
                <!--    <td colspan="2" class=title>비용</td>	-->		
                   <td  class=title>정비업체</td>		
                    <td  class=title>검사책임자</td>
                    <td  class=title>주행거리</td>
                    <td  class=title>첨부</td>
                </tr>
              <!--  
               	<tr>
               	  <td class=title>공급가</td>
           	      <td class=title>부가세</td>
           	   </tr>
           	  -->  
<%
    for(int i=0; i<cc_r.length; i++){
     	   cc_bean = cc_r[i];
     	   
      	  Vector attach_vt  =  new Vector();
      	  int attach_vt_size  =0;
      	  
        
        	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	if ( !cc_bean.getServ_id().equals("") ) {
			String content_code = "SERVICE";
			String content_seq  = cc_bean.getCar_mng_id()+""+cc_bean.getServ_id();
		
			attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			attach_vt_size = attach_vt.size();		
	}
%>
            	<tr>
                	<td width=12% align="center"><%if(cc_bean.getCha_st().equals("1")){%>LPG장착<%}else if(cc_bean.getCha_st().equals("2")){%>LPG탈착<%}else if(cc_bean.getCha_st().equals("3")){%>기타<%}else if(cc_bean.getCha_st().equals("4")){%>계기판교환<%}%></td>
                	<td width=28% align="center"><%=cc_bean.getCha_item()%></td>
                    <td width=10% align="center"><input type="text" name="c_s_dt" value="<%=cc_bean.getCha_st_dt()%>" size="11" class=whitetext></td>
                <!--	<td width=12% align="center"><input type="text" name="c_amt" value="<%=cc_bean.getCha_amt()%>" size="10" class=whitenum>원</td>					
                    <td width=12% align="center"><input type="text" name="c_v_amt" value="<%=cc_bean.getCha_v_amt()%>" size="10" class=whitenum>원</td> -->
                    <td width=16% align="center"><%=cc_bean.getOff_nm()%></td>
                    <td width=16% align="center"><%=cc_bean.getCha_nm()%></td>
                     <td width=10% align="right"><%=Util.parseDecimal(cc_bean.getB_dist())%></td>
                     <td width=8% align="center">     
                <%   if ( !cc_bean.getServ_id().equals("") ) {                %>
                    	<%if(attach_vt_size > 0){%>
			    <%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    					<%if(j+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
        			<%} %>  
        	    <%} %>  	
                     </td>

                </tr>
<%}%>
<% if(cc_r.length == 0) { %>
            <tr>
                <td colspan=7 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
<%
	}else{
%>
			    <tr>
                    <td class=title>구분</td>								
                    <td  class=title>내용</td>
                    <td  class=title>시행일자</td>
				<!--	<td colspan="2" class=title>비용</td>		-->	
                    <td  class=title>정비업체</td>
                    <td  class=title>검사책임자</td>
                    <td  class=title>주행거리</td>
                     <td  class=title>첨부</td>
                     <td  class=title>처리</td>
                </tr>
			 <!--
			    <tr>
			      <td class=title>공급가</td>
			      <td class=title>부가세</td>
		      </tr>
		     --> 
<%
    for(int i=0; i<cc_r.length; i++){
        cc_bean = cc_r[i];
%>
            	<tr>
                	<td align="center"><a href="javascript:ChaUp('<%=cc_bean.getSeq_no()%>','<%=cc_bean.getCha_item()%>','<%=cc_bean.getCha_st_dt()%>','<%=cc_bean.getCha_end_dt()%>','<%=cc_bean.getCha_nm()%>','<%=cc_bean.getCha_st()%>')"><%if(cc_bean.getCha_st().equals("1")){%>LPG장착<%}else if(cc_bean.getCha_st().equals("2")){%>LPG탈착<%}else if(cc_bean.getCha_st().equals("3")){%>기타<%}else if(cc_bean.getCha_st().equals("4")){%>계기판교환<%}%></a></td>
                	<td align="center"><a href="javascript:ChaUp('<%=cc_bean.getSeq_no()%>','<%=cc_bean.getCha_item()%>','<%=cc_bean.getCha_st_dt()%>','<%=cc_bean.getCha_end_dt()%>','<%=cc_bean.getCha_nm()%>','<%=cc_bean.getCha_st()%>')"><%=cc_bean.getCha_item()%></a></td>					
                    <td align="center"><input type="text" name="c_s_dt" value="<%=cc_bean.getCha_st_dt()%>" size="11" class=whitetext></td>
            <!--        <td align="center"><input type="text" name="c_amt" value="<%=cc_bean.getCha_amt()%>" size="8" class=whitenum>원</td>
                    <td align="center"><input type="text" name="c_v_amt" value="<%=cc_bean.getCha_v_amt()%>" size="8" class=whitenum>원</td> -->
                    <td align="center"><%=cc_bean.getOff_nm()%></td>					
                      <td align="center"><%=cc_bean.getCha_nm()%></td>					
                	   <td align="right"><%=Util.parseDecimal(cc_bean.getB_dist())%></td>
                      <td align="center"></td>
                      <td align="center"></td>
                </tr>
<%}%>
                <tr>
                	<td width=12% align="center">
					  <select name="cha_st">
		    			<option value="">선택</option>
		    			<option value="1">LPG장착</option>
    					<option value="2">LPG탈착</option>
    					<option value="3">기타</option>		
    					<option value="4">계기판 교환</option>     				    			 												
    				  </select>	</td>
                	<td width=28% align="center"><input type="text" name="cha_item" value="" size="35" class=text></td>
                    <td width=10% align="center"><input type="text" name="cha_st_dt" value="" size="11" class=text onBlur="javascript:ChangeDT('st_dt')"></td>
    	          <td width=16% align="center"><input type="text" name="off_nm" value="" size="20" class=text></td>	
    	          <td width=16% align="center"><input type="text" name="cha_nm" value="" size="20" class=text></td>	
    	          <td width=10% align="right"></td>					
                	<td width=8% align="center"></td>
                	<td width=10% align="center">
			  <a href="javascript:CarChaReg()"><img src="/acar/images/center/button_in_plus.gif" align="absmiddle" border="0"></a>&nbsp;
			  <a href="javascript:CarChaUp()"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a></td>
	
                </tr>
<%
	}
%>
           </table>
        </td>
    </tr>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="seq_no" value="">
</form>
</table>

<script language="JavaScript">
<!--
<%
	if(cmd.equals("u"))
	{
		if(count==1)
		{
%>

alert("정상적으로 수정되었습니다.");
<%
		}
	}else{
		if(count==1)
		{
%>
alert("정상적으로 등록되었습니다.");
<%
		}
	}
%>
//-->
</script> 
</body>
</html>