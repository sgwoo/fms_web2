<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");		
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "01");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();	

	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);	
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());	
	String rent_st = rc_bean.getRent_st();
%>

<html>
<head>

<title>예약시스템 <%if(mode.equals("R")){%>반차처리<%}else{%>기간연장<%}%></title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
		if(fm.mode.value == 'R'){
			if(fm.ret_dt.value == ''){ 		alert('반차일시를 입력하십시오'); 			fm.ret_dt.focus(); 			return; }
			if(fm.ret_loc.value == ''){ 	alert('반차위치를 입력하십시오'); 			fm.ret_loc.focus(); 		return; }		
			if(fm.ret_mng_id.value == ''){ 	alert('반차담당자를 선택하십시오'); 		fm.ret_mng_id.focus(); 		return; }						
			if(fm.ret_dt.value != '')
				fm.h_ret_dt.value = fm.ret_dt.value+fm.ret_dt_h.value;			
		}else{
			if(fm.add_dt.value == ''){ 		alert('연장일자를 입력하십시오'); 			fm.add_dt.focus(); 			return; }		
		}
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'res_action_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.<%if(mode.equals("R")){%>ret_dt<%}else{%>add_dt<%}%>.focus();">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='h_ret_dt' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width=480>
    <tr> 
      <td><font color="navy">예약시스템 -> 반차관리</font>-> <font color="red"><%if(mode.equals("R")){%>반차처리<%}else{%>기간연장<%}%></font></td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="1" width=480>
          <tr> 
            <td class=title>계약구분</td>
            <td align="center"> 
               <%if(rent_st.equals("1")){%>
                단기대여 
                <%}else if(rent_st.equals("2")){%>
                정비대차 
                <%}else if(rent_st.equals("3")){%>
                사고대차 
                <%}else if(rent_st.equals("9")){%>
                보험대차 
                <%}else if(rent_st.equals("10")){%>
                지연대차 
                <%}else if(rent_st.equals("4")){%>
                업무대여 
                <%}else if(rent_st.equals("5")){%>
                업무지원 
                <%}else if(rent_st.equals("6")){%>
                차량정비 
                <%}else if(rent_st.equals("7")){%>
                차량점검 
                <%}else if(rent_st.equals("8")){%>
                사고수리 
                <%}else if(rent_st.equals("11")){%>
                장기대기
                <%}else if(rent_st.equals("12")){%>
                월렌트
                <%}%>	
            </td>
            <td class=title>차량번호</td>
            <td align="center"><%=reserv.get("CAR_NO")%></td>
            <td class=title>성명</td>
            <td align="left">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title>상호</td>
            <td align="center"><%=rc_bean2.getFirm_nm()%></td>
          </tr>
          <tr> 
                    <td class=title width=12%>차명</td>
                    <td colspan="7">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                </tr>  
          <tr> 
            <td class=title>대여기간</td>
            <td colspan="7"> <%=AddUtil.ChangeDate4(rc_bean.getRent_start_dt())%>시 
              ~ <%=AddUtil.ChangeDate4(rc_bean.getRent_end_dt())%>시</td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(!rc_bean.getSub_c_id().equals("")){ 
    	//차량정보
    	Hashtable reserv2 = rs_db.getCarInfo(rc_bean.getSub_c_id());
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>원인차량</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>    
                <tr>            
                    <td class=title width=10%>차량번호</td>
                    <td width=20%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>차명</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>    
    <%if(rc_bean.getSub_c_id().equals("") && !rc_bean.getSub_l_cd().equals("")){ 
    	//차량정보
    	Hashtable reserv2 = a_db.getRentBoardSubCase(rc_bean.getSub_l_cd());
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>원인차량</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2">          
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                
                    <td class=title width=10%>차량번호</td>
                    <td width=20%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>차명</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>    
    <tr> 
      <td>&nbsp;</td>
    </tr>
	<%if(mode.equals("R")){%>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="1" width=480>
          <tr> 
            <td class=title width="80">반차예정일시</td>
            <td><%=AddUtil.ChangeDate4(rc_bean.getRet_plan_dt())%>시</td>
          </tr>
          <tr> 
            <td class=title>반차일시</td>
            <td> 
              <input type="text" name="ret_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
              <select name="ret_dt_h">
                <%for(int i=0; i<25; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
            </td>
          </tr>
          <tr> 
            <td class=title>반차위치</td>
            <td>
              <input type="text" name="ret_loc" value="<%=rc_bean.getRet_loc()%>" size="60" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title>반차담당자</td>
            <td>
              <select name='ret_mng_id'>
                <option value="">미지정</option>
                <%if(user_size > 0){
					for (int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getRet_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%	}
				}%>
              </select>
			</td>
          </tr>
        </table>
      </td>
    </tr>
	<%}else if(mode.equals("A")){%>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="1" width=480>
          <tr> 
            <td class=title width="80">반차예정일시</td>
            <td><%=AddUtil.ChangeDate4(rc_bean.getRet_plan_dt())%>시</td>
          </tr>
          <tr> 
            <td class=title>연장일자</td>
            <td> 
              <input type="text" name="add_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
          </tr>
        </table>
      </td>
    </tr>
	<%}%>		
    <tr> 
      <td align="right">
	  	<%if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) && (br_id.equals("S1") || rc_bean.getBrch_id().equals(br_id))){%>		  	  	  
	    <a href='javascript:save();'> 
        <img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"> 
        </a>&nbsp;
	  	<%}%>							
	    <a href='javascript:document.form1.reset();'> 
        <img src="/images/calcel.gif" width="50" height="18" aligh="absmiddle" border="0"> 
        </a>&nbsp;		
	    <a href="javascript:self.close()" onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
