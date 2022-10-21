<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");


	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	int idx = request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//연체횟수
	int dly_mon = af_db.getFeeScdDlyCnt(m_id, l_cd);
	
	//일시중지정보
	Hashtable ht = a_db.getCarCallIn(m_id, l_cd, seq);
	
	String in_st 	= String.valueOf(ht.get("IN_ST"))=="null"?"":String.valueOf(ht.get("IN_ST"));
	String in_dt 	= String.valueOf(ht.get("IN_DT"))=="null"?"":String.valueOf(ht.get("IN_DT"));
	String in_cau 	= String.valueOf(ht.get("IN_CAU"))=="null"?"":String.valueOf(ht.get("IN_CAU"));
	String out_dt 	= String.valueOf(ht.get("OUT_DT"))=="null"?"":String.valueOf(ht.get("OUT_DT"));
	String reg_dt 	= String.valueOf(ht.get("REG_DT"))=="null"?"":String.valueOf(ht.get("REG_DT"));
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;

		<%if(nm_db.getWorkAuthUser("본사관리팀장",ck_acar_id) || nm_db.getWorkAuthUser("보유차관리자들", ck_acar_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>			
		if(fm.in_st[0].checked != true && fm.in_st[1].checked != true && fm.in_st[2].checked != true && fm.in_st[3].checked != true){	alert('회수구분을 선택하십시오'); 		fm.in_st[0].focus(); 	return; }
		<%}else{%>
		<%		if(!seq.equals("")){//수정%>
		if('<%=out_dt%>'=='' && fm.out_dt.value != ''){
			alert('해지등록회수의 해제처리는 회수처리 권한이 있는 사람만 할수 있습니다.');
			return;
		}		
		<%		}%>		
		if(fm.in_st[0].checked != true && fm.in_st[1].checked != true){	alert('회수구분을 선택하십시오'); 		fm.in_st.focus(); 	return; }
		<%}%>
		if(fm.in_dt.value 	== '')			{	alert('차량회수일자를 입력하십시오'); 							fm.in_dt.focus(); 		return; }
		if(fm.in_cau.value 	== '')			{	alert('차량회수사유를 입력하십시오'); 							fm.in_cau.focus(); 		return; }
				
		if(confirm('차량임시회수를 등록하시겠습니까?'))
		{							
			fm.action = './car_call_in_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
  }
	
	//차량대수에 따른 디스플레이
	function cng_input(in_st){
		var fm = document.form1;
		if(in_st =='1'){
			tr_out.style.display	= '';
		}else if(in_st =='2'){
			tr_out.style.display	= '';
		}else if(in_st =='3'){
			tr_out.style.display	= 'none';
		}else if(in_st =='4'){
			tr_out.style.display	= 'none';
		}
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body topmargin=0 leftmargin=0>

<form action='' method="post" name='form1'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr><td class=line2></td></tr>
    <tr>
	    <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
	        <%if(dly_mon > 0){%>
                <tr>
                    <td width='200' class='title'>현재현황</td>
                    <td>&nbsp; 
                      <%=dly_mon%>개월 연체
                    </td>
                </tr>
	        <%}%>
                <tr>
                    <td width='200' class='title'>구분</td>
                    <td>&nbsp;
					  <%if(nm_db.getWorkAuthUser("본사관리팀장",ck_acar_id) || nm_db.getWorkAuthUser("보유차관리자들",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>		
                      <input type="radio" name="in_st" value="1" <%if(in_st.equals("1") || in_st.equals(""))%>checked<%%>  onClick="javascript:cng_input(1)">
                      연체
                      <input type="radio" name="in_st" value="2" <%if(in_st.equals("2"))%>checked<%%> onClick="javascript:cng_input(2)"> 
                      고객요청
					  <input type="radio" name="in_st" value="3" <%if(in_st.equals("3"))%>checked<%%> onClick="javascript:cng_input(3)"> 
                      해지반납
					  <input type="radio" name="in_st" value="4" <%if(in_st.equals("4"))%>checked<%%> onClick="javascript:cng_input(4)"> 
                      해지전 보험관리
					  <%}else{%>
					  <input type="radio" name="in_st" value="3" <%if(in_st.equals("3"))%>checked<%%> onClick="javascript:cng_input(3)" >
                      해지반납
					  <input type="radio" name="in_st" value="4" <%if(in_st.equals("4"))%>checked<%%> onClick="javascript:cng_input(4)" >
                      해지전 보험관리
					  <%}%>
                    </td>
                </tr>
                <tr>
                    <td class='title'>회수일자</td>
                    <td>&nbsp;
					  <input type='text' name='in_dt' value='<%=AddUtil.ChangeDate2(in_dt)%>' maxlength='11' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr>
                    <td class='title'>사유</td>
                    <td>&nbsp;
                      <textarea name="in_cau" cols="80" rows="3" class=default><%=in_cau%></textarea>
                    </td>
                </tr>
                <tr id=tr_out style="display:<%if(in_st.equals("")){%>none<%}else{%>''<%}%>">
                    <td class='title'>
					<%if(in_st.equals("")){%>
					인도/해지일자
					<%}else if(in_st.equals("3") || in_st.equals("4")){%>
					해지일자
					<%}else{%>
					차량인도일자
					<%}%>
					</td>
                    <td>&nbsp;
                    <input type='text' name='out_dt' value='<%=AddUtil.ChangeDate2(out_dt)%>' maxlength='11' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
			        </td>
                </tr>
                <tr>
                    <td class='title'>등록일자</td>
                    <td>&nbsp;
                    <%=AddUtil.ChangeDate2(reg_dt)%>
			        </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
	    <td>* 계약담당자는 해지반납, 해지전 보험정리만 처리할 수 있으며, 해지반납 등록시 예약시스템에서 보유차로 운행이 됩니다.</td>
    </tr>	
    <tr>
	    <td>* 연체, 고객요청으로 임시회수한 경우 고객지원팀 보유차관리자(계성진님) 혹은 고객지원팀장(김광수님)에게 회수처리 요청하십시오.</td>
    </tr>	
    <tr>
	<td align="center">
	    <%if(!mode.equals("view")){%>
	        <%//if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
      		    <%if(seq.equals("")){//등록%>
			          <a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
		          <%}else{//수정%>
			          <a href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
		          <%}%>
	        <%//}%>
      <%}%>
      	    &nbsp;&nbsp;
      	    <a href="javascript:parent.window.close();"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>      		
        </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
