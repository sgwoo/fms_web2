<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?	"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈

	//quick link 후  parameter값 초기화되는 경우 발생 - 
	if(gubun4.equals("") && gubun5.equals("") ){
		gubun4 = "1";
		gubun5 = "1";
	}
		
	String valus = 	"?height="+height+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+sh_height+"";

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//계약서 내용 보기
	function view_cont(m_id, l_cd, use_yn, car_st, now_stat, san_st, reg_step){
		var fm = document.form1;
		fm.rent_mng_id.value = m_id;
		fm.rent_l_cd.value = l_cd;		
		if(car_st == '예비') 		fm.c_st.value = 'car';
		if(car_st == '중고차') 	fm.c_st.value = 'car_ac';
		fm.now_stat.value = now_stat;
		fm.target ='d_content';
		
		if(car_st=='월렌트'){		
			fm.action = 'lc_c_frame.jsp';			
		}else{
			if(use_yn == ''){
				if(use_yn == '' && san_st == '요청'){
					fm.action = 'lc_b_c.jsp';	
				}else if(use_yn == '' && car_st == '중고차'){
					fm.action = 'lc_b_u_ac.jsp';
				}else{
					if(reg_step != '' && san_st == '미결' && now_stat != '계약승계' && now_stat != '차종변경' && now_stat != '연장' && reg_step != '4'){
						if(reg_step == '1')			fm.action = 'lc_reg_step2.jsp';
						else if(reg_step == '2')	fm.action = 'lc_reg_step3.jsp';
						else if(reg_step == '3')	fm.action = 'lc_reg_step4.jsp';
						if(reg_step == '2' && car_st == '업무대여')		fm.action = 'lc_reg_step4.jsp';
					}else{
						fm.action = 'lc_b_s.jsp';	
					}					
				}
			}else{					
				fm.action = 'lc_c_frame.jsp';				
			}
		}		
				
		
		fm.submit();
	}
	//계약정보 보기
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
	//자동차등록정보 보기
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}	
	function view_car_exp(c_id)
	{
		window.open("/fms2/precost/view_exp_car_list.jsp?car_mng_id="+c_id, "VIEW_CAR2", "left=100, top=100, width=850, height=600, scrollbars=yes");		
	}				
	function view_car_tax(c_id)
	{
		window.open("/fms2/precost/view_tax_car_list.jsp?car_mng_id="+c_id, "VIEW_CAR3", "left=100, top=100, width=850, height=650, scrollbars=yes");		
	}				
	//통합메모
	function view_memo2(m_id, l_cd)
	{
		window.open("/acar/settle_acc/memo_frame_s.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd, "MEMO", "left=50, top=50, width=800, height=700");
	}
	//대여료메모
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
//		window.open("/fms2/con_fee/fee_memo_frame_s.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "FEE_MEMO", "left=0, top=0, width=850, height=750, scrollbars=yes");
	}		
	
		
	//스캔관리 보기
	function view_scan(m_id, l_cd)
	{
		window.open("view_scan.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, scrollbars=yes, status=yes");								
	}
	//차량예약현황 조회
	function view_res(c_id){
	
	          if ( c_id == '' ) {  alert("등록된 차량이 없습니다.") ;
	          } else {
			var fm = document.form1;
			var SUBWIN="view_res.jsp?c_id="+c_id+"&auth_rw="+fm.auth_rw.value;	
			window.open(SUBWIN, "VIEW_RES", "left=50, top=50, width=1050, height=600, scrollbars=yes, status=yes");
		}
	}
		
			
	//문자 발송
	function view_sms_send(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_sms.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&memo_st=client", "CREDIT_MEMO_SMS", "left=220, top=20, width=800, height=850");
	}		
//-->
</script>
</head>

<body >
<form name='form1' method='post' target='d_content'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/lc_rent/lc_s_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='c_st' value='client'>  
  <input type='hidden' name='now_stat' value=''>      
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span></td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="lc_s_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
