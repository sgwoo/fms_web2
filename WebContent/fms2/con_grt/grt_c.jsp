<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.ext.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.ExtDatabase"/>
<jsp:useBean id="f_db" scope="page" class="acar.fee.FeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_to_list()
	{
		var fm 		= document.form1;
		var auth_rw = fm.auth_rw.value;
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		location = "/fms2/con_grt/grt_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	
	Hashtable fee = f_db.getFeebase(m_id, l_cd);

	Vector grts = ae_db.getExtScd(m_id, l_cd, r_st, "0");
	int grt_size = grts.size();
	Vector pps = ae_db.getExtScd(m_id, l_cd, r_st, "1");
	int pp_size = pps.size();
	Vector ifees = ae_db.getExtScd(m_id, l_cd, r_st, "2");
	int ifee_size = ifees.size();
%>
<form name='form1' method='post'>
<!-- 다시 리스트로 갈때 검색조건을 세팅하기 위한 argument들-->
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='p_st' value=''>
<input type='hidden' name='tm' value=''>
<input type='hidden' name='pay_dt' value=''>
<input type='hidden' name='pay_amt' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td>
			<font color="navy">계약관리  -> </font><font color="navy">선수금 및 보증금 관리 </font>-> </font><font color="red">선수금 및 보증금 수금 </font>
		</td>
	</tr>
	<tr>
		<td align='right'><a href="javascript:go_to_list()" onMouseOver="window.status=''; return true">리스트로</a></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=800>
					<tr>
						<td width='90' class='title'>계약번호</td>
						<td width='100'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
						<td width='80' class='title'>상호</td>
						<td width='200'>&nbsp;<%=fee.get("FIRM_NM")%></td>
						<td width='80' class='title'>계약자</td>
						<td width='250' colspan='3'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
					</tr>
					<tr>
						<td width='90' class='title'>차량번호</td>
						<td width='100'>&nbsp;<%=fee.get("CAR_NO")%></td>
						<td width='80' class='title'>차명</td>
						<td width='200'>&nbsp;<%=fee.get("CAR_NM")%></td>
						<td width='80' class='title'> 대여방식 </td>
						<td width='100'>&nbsp;
                    <%if(fee.get("RENT_WAY").equals("1")){%>
                    일반식 
                    <%}else if(fee.get("RENT_WAY").equals("2")){%>
                    맞춤식 
                    <%}else{%>
                    기본형 
                    <%}%>
						</td>
						<td width='80'>&nbsp;<%if(r_st.equals("1")){%><%=fee.get("CON_MON")%><%}else{%><%=fee.get("EX_CON_MON")%><%}%>개월</td>
					</tr>			
			</table>
		</td>
	</tr>
</table>

<br/>

<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td align='left'>*보증금</td>
	</tr>
<%
	if(grt_size > 0)
	{
%>	
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td width='80'  class='title'> 회차	</td>
					<td width='120'  class='title'> 공급가	</td>
					<td width='120'  class='title'> 부가세	</td>
					<td width='120' class='title'> 합계		</td>
					<td width='120' class='title'> 약정일	</td>
					<td width='120' class='title'> 입금일	</td>
					<td width='120' class='title'> 입금액	</td>
				</tr>
<%
		for(int i = 0 ; i < grt_size ; i++)
		{
			GrtScdBean grt = (GrtScdBean)grts.elementAt(i);
%>
				<tr>
					<td width='80'  align='center'><%=grt.getPp_tm()%>회</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_s_amt())%>원&nbsp;</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_v_amt())%>원&nbsp;</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_s_amt()+grt.getPp_v_amt())%>원&nbsp;</td>
					<td width='120' align='center'><%=grt.getPp_est_dt()%></td>
					<td width='120' align='center'><%=grt.getPp_pay_dt()%></td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_pay_amt())%>원&nbsp;</td>
				</tr>
<%
		}
%>
			</table>
		</td>
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td>보증금내역이 없습니다</td>
	</tr>
<%
	}
%>
	<tr>
		<td align='left'>*개시대여료</td>
	</tr>
<%
	if(ifee_size > 0)
	{
%>	
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td width='80'  class='title'> 회차	</td>
					<td width='120'  class='title'> 공급가	</td>
					<td width='120'  class='title'> 부가세	</td>
					<td width='120' class='title'> 합계		</td>
					<td width='120' class='title'> 약정일	</td>
					<td width='120' class='title'> 입금일	</td>
					<td width='120' class='title'> 입금액	</td>
				</tr>
<%
		for(int i = 0 ; i < ifee_size ; i++)
		{
			GrtScdBean grt = (GrtScdBean)ifees.elementAt(i);
%>		
				<tr>
					<td width='80'  align='center'><%=grt.getPp_tm()%>회</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_s_amt())%>원&nbsp;</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_v_amt())%>원&nbsp;</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_s_amt()+grt.getPp_v_amt())%>원&nbsp;</td>
					<td width='120' align='center'><%=grt.getPp_est_dt()%></td>
					<td width='120' align='center'><%=grt.getPp_pay_dt()%></td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_pay_amt())%>원&nbsp;</td>
				</tr>
<%
		}
%>				
			</table>
		</td>
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td>개시대여료내역이 없습니다</td>
	</tr>
<%
	}
%>		
	<tr>
		<td></td>
	</tr>
	<tr>
		<td align='left'>*선납금</td>
	</tr>
<%
	if(pp_size > 0)
	{
%>		
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td width='80'  class='title'> 회차	</td>
					<td width='120'  class='title'> 공급가	</td>
					<td width='120'  class='title'> 부가세	</td>
					<td width='120' class='title'> 합계		</td>
					<td width='120' class='title'> 약정일	</td>
					<td width='120' class='title'> 입금일	</td>
					<td width='120' class='title'> 입금액	</td>
				</tr>
<%
		for(int i = 0 ; i < pp_size ; i++)
		{
			GrtScdBean grt = (GrtScdBean)pps.elementAt(i);
%>		
				<tr>
					<td width='80'  align='center'><%=grt.getPp_tm()%>회</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_s_amt())%>원&nbsp;</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_v_amt())%>원&nbsp;</td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_s_amt()+grt.getPp_v_amt())%>원&nbsp;</td>
					<td width='120' align='center'><%=grt.getPp_est_dt()%></td>
					<td width='120' align='center'><%=grt.getPp_pay_dt()%></td>
					<td width='120' align='right'><%=Util.parseDecimal(grt.getPp_pay_amt())%>원&nbsp;</td>
				</tr>
<%
		}
%>				
			</table>
		</td>
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td>선납금내역이 없습니다</td>
	</tr>
<%
	}
%>	
	<tr>
		<td></td>
	</tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
