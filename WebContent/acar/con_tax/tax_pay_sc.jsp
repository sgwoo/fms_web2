<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	//세부내용 보기
	function view_tax(m_id, l_cd, c_id, seq, rent_mon, cls_st, tax_come_dt)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq.value = seq;
		fm.rent_mon.value = rent_mon;		
		fm.cls_st.value = cls_st;				
		fm.tax_come_dt.value = tax_come_dt;				
		if(seq == ''){
			fm.action = 'tax_scd_i.jsp';
		}else{
			fm.action = 'tax_scd_u.jsp';
		}
		fm.target= 'd_content';
		fm.submit();
	}
	//세부내용 보기
	function view_tax2(tax_st, m_id, l_cd, c_id, seq, rent_mon, cls_st, tax_come_dt, dlv_mon)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq.value = seq;
		fm.rent_mon.value = rent_mon;		
		fm.cls_st.value = cls_st;				
		fm.tax_st.value = tax_st;	
		fm.tax_come_dt.value = tax_come_dt;				
		fm.dlv_mon.value = dlv_mon;						
		if(seq == ''){
			fm.action = 'tax_scd_i.jsp';
		}else{
			fm.action = 'tax_scd_u.jsp';
		}
		fm.target= 'd_content';
		fm.submit();
	}	

	//리스트 엑셀 전환
	function pop_excel(idx){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_excel"+idx+".jsp";
		fm.submit();
	}	
	
	//리스트 엑셀 전환
	function pop_excel_1(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_excel1_t.jsp";
		fm.submit();
	}
	//리스트 신고엑셀폼
	function pop_excel_2(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_excel1_e2.jsp"; //20170713 수정본
		fm.submit();
	}
	//리스트  국세청요청자료 - 과세물품 총판매(반출)명세서
	function pop_excel_3(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_excel1_e3.jsp"; 
		fm.submit();
	}
				
	//스케줄관리 이동
	function tax_scd(){
		var fm = document.form1;
		fm.gubun2.value = '5';
		fm.gubun3.value = '2';		
		fm.sort_gubun.value = "3";
		fm.asc.value = "1";
		fm.target = "d_content";
		fm.action = "tax_scd_frame_s.jsp";
		fm.submit();
	}	
	
	//스케줄관리 이동
	function stat_tax(){
		var fm = document.form1;
		fm.gubun2.value = '5';
		fm.gubun3.value = '2';		
		fm.sort_gubun.value = "3";
		fm.asc.value = "1";
		fm.target = "d_content";
		fm.action = "stat_tax_frame_s.jsp";
		fm.submit();
	}			
	
	//일괄등록
	function select_reg(){
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("개별소비세 등록할 계약을 선택하세요.");
			return;
		}	
		fm.target = "i_no2";
//		fm.target = "_blank";
		fm.action = "tax_est_reg_all.jsp";
		fm.submit();	
	}				
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String nb_dt = request.getParameter("nb_dt")==null?"":request.getParameter("nb_dt");
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='/acar/con_tax/tax_pay_sc.jsp' target='' method='post'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='cls_st' value=''>
<input type='hidden' name='tax_st' value=''>
<input type='hidden' name='rent_mon' value=''>
<input type='hidden' name='dlv_mon' value=''>
<input type='hidden' name='tax_come_dt' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='nb_dt' value='<%=nb_dt%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='est_mon' value='<%=est_mon%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='pay'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
<tr> </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%'>
	<tr>
		<td align='right' width=100%'>
			<a href='javascript:stat_tax()'><img src=../images/center/button_tss.gif align=absmiddle border=0></a>
<%if(gubun3.equals("2")){//등록%>
			<a href="javascript:pop_excel(1);"><img src=../images/center/button_jg_excel.gif border=0 align=absmiddle></a>
			<a href="javascript:pop_excel(2);"><img src=../images/center/button_mg_excel.gif border=0 align=absmiddle></a>
			<a href="javascript:pop_excel(5);"><img src=../images/center/button_excel_ydbg.gif border=0 align=absmiddle></a>			
			
			신고엑셀폼 : <a href="javascript:pop_excel_2();"><img src=../images/center/button_excel.gif border=0 align=absmiddle></a>
			
			<%if(ck_acar_id.equals("000029") || ck_acar_id.equals("000129") || ck_acar_id.equals("000131")){%>
			/ 국세청요청자료 : 신고일
			<input type='text' size='8' name='excel_s_dt' maxlength='10' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
			~
			<input type='text' size='8' name='excel_e_dt' maxlength='10' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
			<a href="javascript:pop_excel_3();"><img src=../images/center/button_excel.gif border=0 align=absmiddle></a>
			<%}%>	
			
<%	}%>			
		</td>
	</tr>
	<tr>
		<td>
		<%if(!gubun2.equals("5")){%>
		<%	if(gubun3.equals("2")){%>
			<iframe src="/acar/con_tax/tax_pay_sc_in.jsp?height=<%=height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&nb_dt=<%=nb_dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='auto' marginwidth='0' marginheight='0'></iframe>
		<%	}else{%>			
			<iframe src="/acar/con_tax/tax_est_sc_in.jsp?height=<%=height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&nb_dt=<%=nb_dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='auto' marginwidth='0' marginheight='0'></iframe>		
		<%	}
		  }else{%>
		    <iframe src="/acar/con_tax/tax_pay_sc_in.jsp?height=<%=height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&nb_dt=<%=nb_dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='auto' marginwidth='0' marginheight='0'></iframe>					
			<!-- <iframe src="/acar/con_tax/tax_reg_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&nb_dt=<%=nb_dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='auto' marginwidth='0' marginheight='0'></iframe> -->		
		<%	}%>		  
		</td>
	</tr>
	<tr>
	</tr>
	<tr>
		<td width=100%>&nbsp;&nbsp;<span class=style4>* 납부사유발생일자 : 장기대여 = 대여개시 12개월 도래일자 / 용도변경 = 용도변경일자 / 매각 = 명의이전일자  * 기간검색시 회계처리일로 검색됩니다.</span></td>
	</tr>
      </table>
    </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no2" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>