<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='javascript'>
<!--
	//해지 등록
	function go_cancel()
	{
		var fm = document.form1;
		var i_fm = i_inner.form1;

		var ch_size = i_fm.c_cls_reg.length;	//등록 라디오버튼
		var flag = 0;
		var ch_val;
		if(ch_size == undefined){
			if(i_fm.c_cls_reg.checked == true){
				flag = 1;
				ch_val = i_fm.c_cls_reg.value;
			}
		}else{
			for(var i = 0 ; i < ch_size ; i++){
				if(i_fm.c_cls_reg[i].checked == true){
					flag = 1;
					ch_val = i_fm.c_cls_reg[i].value;
				}
			}
		}
		
		if(flag != 1){	alert('계약을 선택하십시오');	return;	}

		var idx = fm.s_cls_st.options[fm.s_cls_st.selectedIndex].value;
		if(idx == '0'){	alert('해지구분을 선택하세요');	return;	}
		
		if(ch_val.length != 19)		//계약관리번호 & 계약코드
			return;
		fm.rent_mng_id.value 	= ch_val.substr(0, 6);
		fm.rent_l_cd.value 		= ch_val.substr(6, 13);
		
		fm.cls_st.value = idx;
		
		if((idx == '2')||(idx == '4'))	fm.action ='./ccl_settle_i.jsp';	//2:중도해약, 4:출고후 차종 변경
		else							fm.action ='./ccl_nosettle_i.jsp';	//1:출고전해지, 3:출고전차종변경, 5:영업소변경

		fm.target='d_content';
		fm.submit();
	}
	
	//고객정보 보기
	function view_client(rent_mng_id, rent_l_cd, r_st, cls_st)
	{
		window.open("/acar/cls_con/cls_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st+"&cls_st="+cls_st, "VIEW_CLIENT", "left=100, top=50, width=720, height=600, scrollbars=yes");
	}
	
	//미처리된것 처리
	function close_cont(rent_mng_id, rent_l_cd, cls_st)
	{
		var fm = document.form1;
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value 	= rent_l_cd;
		fm.cls_st.value 	= cls_st;
		fm.target='i_no';
				
		if(cls_st == '3'){	//출고전 차종변경
			if(confirm('해지처리시 새로운 계약을 작성합니다. \n계속하시겠습니까?')){
				fm.action='./con_reg_frame.jsp';
				fm.target='d_content';
				fm.submit();
			}
		}else if(cls_st == '4'){	//출고후 차종변경
			if(confirm('해지처리시 새로운 계약을 작성합니다. \n잔여 미수금 대여료가 있는경우 새 계약코드로 자료를 이전합니다. \n계속하시겠습니까?')){
				fm.action='/./con_reg_frame.jsp';
				fm.target='d_content';
				fm.submit();
			}
		}else if(cls_st == '5'){	//영업소변경
			if(confirm('계약을 해지처리하고 이전 영업소코드로 새롭게 계약을 등록합니다. \n처리하시겠습니까?')){
				fm.action='./cls_cont_u_a.jsp';
				fm.submit();
			}
		}else{
			if(confirm('계약을 해지처리합니다. \n잔여 미수금 대여료가 있는경우 삭제됩니다. \n처리하시겠습니까?')){
				fm.action='./cls_cont_u_a.jsp';
				fm.submit();
			}
		}
	}
	
	//중도해지 조회
	function view_cls(rent_mng_id, rent_l_cd, cls_st)
	{
		var fm = document.form1;
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.target='d_content';
		if((cls_st == '2')||(cls_st == '4'))	fm.action ='./ccl_settle_c.jsp';	//2:중도해약, 4:출고후 차종 변경
		else									fm.action ='./ccl_nosettle_c.jsp';	//1:출고전해지, 3:출고전차종변경, 5:영업소변경
		fm.submit();
	}
//-->
</script>
</head>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String r_cls	 	= request.getParameter("r_cls")==null?"0":request.getParameter("r_cls");
	String s_cls_st	 	= request.getParameter("s_cls_st")==null?"0":request.getParameter("s_cls_st");
	String s_kd		 	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd		 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String t_st_dt	 	= request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");	
	String t_end_dt	 	= request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");	
%>
<body>
<form name='form1' target='d_content' method='post'>
<input type='hidden' name='rent_mng_id' value=''>
<input type='hidden' name='rent_l_cd' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='cls_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td>
			<table border="0" cellspacing="1" cellpadding="0" width=800>
<%	if(r_cls.equals("0")){//해약리스트	%>
				<tr>
					<td width='800'>
						<table border="0" cellspacing="1" cellpadding="0" width=800>
							<tr>
								<td align='left' width='800'>구분 - 1:출고전해지&nbsp;&nbsp;2:중도해지&nbsp;&nbsp;3:출고전차종변경&nbsp;&nbsp;4:출고후차종변경&nbsp;&nbsp;5:영업소변경</td>
							</tr>
						</table>
					</td>
				</tr>
<%	}else{	//미해약리스트
		if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){	//등록쓰기권한	%>
				<tr>
					<td width='800'>
						<table border="0" cellspacing="1" cellpadding="0" width=800>
							<tr>
								<td align='right' width='800'>
									해지등록 :&nbsp;
									<select name='s_cls_st'>
										<option value='0'>선택</option>
										<option value='1'>출고전해지	</option>
										<option value='2'>중도해지</option>
										<option value='3'>출고전차종변경</option>
										<option value='4'>출고후차종변경</option>
										<option value='5'>영업소변경</option>
									</select>		
									<a href='javascript:go_cancel()' onMouseOver="window.status=''; return true">등록</a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
<%		}
	}			%>
				<tr>
					<td>
						<table border="0" cellspacing="1" cellpadding="0" width=800>
							<tr>
								<td align='center'>
									<iframe src="./cls_sc_in.jsp?auth_rw=<%=auth_rw%>&r_cls=<%=r_cls%>&s_cls_st=<%=s_cls_st%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>" name="i_inner" width="800" height="470" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=auto, marginwidth=0, marginheight=0 >
									</iframe>
								</td>
							</tr>
						</table>
					</td>
				</tr>			
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>