<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");	
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	int idx = request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//세금계산서 발행일시중지관리내역 리스트
	Vector ht = af_db.getFeeScdStopList(m_id, l_cd);
	int ht_size = ht.size();
	
	//연체횟수
	int dly_mon = af_db.getFeeScdDlyCnt(m_id, l_cd);
	
	//일시중지정보
	FeeScdStopBean fee_stop = af_db.getFeeScdStop(m_id, l_cd, seq);	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_stop(seq){
	 	var fm = document.form1;
		fm.seq.value = seq;
		fm.action = 'fee_scd_u_stop.jsp';
		fm.target = 'stopreg';		
		fm.submit();
  	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body>

<form action='' method="post" name='form1'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
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
<input type='hidden' name='rent_start_dt' value='<%=fee.getRent_start_dt()%>'>
<input type='hidden' name='rent_end_dt' value='<%=fee.getRent_end_dt()%>'>
<input type='hidden' name='t_fee_pay_tm' value='<%=fee.getFee_pay_tm()%>'>
<input type='hidden' name='stop_size' value='<%=ht_size%>'>
<input type='hidden' name='today' value='<%=AddUtil.getDate()%>'>
<input type='hidden' name='seq' value='<%=fee_stop.getSeq()%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 대여료스케줄관리 > <span class=style5>
						대여료스케줄 세금계산서 발행 일시중지 관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
	<tr><td class=line2></td></tr>
    <tr>
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>		    	
                <tr>
                    <td width='15%' class='title'>계약번호</td>
                    <td width='20%'>&nbsp;
        			        <%=base.get("RENT_L_CD")%></td>
                    <td width='15%' class='title'>상호</td>
                    <td width="50%">&nbsp;
        			        <%=base.get("FIRM_NM")%></td>
                </tr>
		      <%if(!String.valueOf(base.get("R_SITE")).equals("")){%>
                <tr>
                    <td class='title'>사용본거지</td>
                    <td colspan="3">&nbsp; <%=base.get("R_SITE_NM")%></td>
                </tr>	
		      <%}%>	   
                <tr>
                    <td class='title'>차량번호</td>
                    <td>&nbsp;
        			        <font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;
			        <span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr>
                    <td class='title'> 대여방식 </td>
                    <td>&nbsp;
        			        <%=base.get("RENT_WAY")%></td>
                    <td class='title'>CMS</td>
                    <td>&nbsp;
        				      <%if(!cms.getCms_bank().equals("")){%>
							  <b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
        			 	      <%=cms.getCms_bank()%>:<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>(매월<%=cms.getCms_day()%>일)
        			 	      <%}else{%>
        			      	-
        			 	      <%}%>
        	        </td>
                </tr>
                <tr>
                    <td class='title'>영업담당자</td>
                    <td>&nbsp;
        			        <%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td class='title'>관리담당자</td>
                    <td>&nbsp;
        			        <%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>		   
            </table>
	    </td>
    </tr>
    <tr>
	    <td align='right'>&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr>		
    <tr>
	    <td align='right' class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="5%" class='title'>연번</td>
                    <td width="10%" class='title'>구분</td>
                    <td width="9%" class='title'>분할구분</td>					
                    <td width="20%" class='title'>중지기간</td>
                    <td width="20%" class='title'>사유</td>
                    <td width="10%" class='title'>등록일</td>
                    <td width="8%" class='title'>등록자</td>
                    <td width="10%" class='title'>해제일자</td>
                    <td width="8%" class='title'>해제자</td>
                </tr>
<%		    for(int i = 0 ; i < ht_size ; i++){
			      FeeScdStopBean fee_scd = (FeeScdStopBean)ht.elementAt(i);%>		  		
                 <tr align="center">
                    <td><%=i+1%></td>
                    <td><%if(!fee_scd.getRent_seq().equals("1")&& !fee_scd.getRent_seq().equals("")){%>분할<%=fee_scd.getRent_seq()%><%}%></td>					
                    <td><a href="javascript:view_stop('<%=fee_scd.getSeq()%>')"><%if(fee_scd.getStop_st().equals("1")){%>연체<%}else{%>고객요청<%}%></a></td>
                    <td><%=AddUtil.ChangeDate2(fee_scd.getStop_s_dt())%>~<%=AddUtil.ChangeDate2(fee_scd.getStop_e_dt())%></td>
                    <td><%=fee_scd.getStop_cau()%></td>
                    <td><%=AddUtil.ChangeDate2(fee_scd.getReg_dt())%></td>
                    <td><%=c_db.getNameById(fee_scd.getReg_id(),"USER")%></td>
                    <td><%=AddUtil.ChangeDate2(fee_scd.getCancel_dt())%></td>
                    <td><%=c_db.getNameById(fee_scd.getCancel_id(),"USER")%></td>
                </tr>
<%		    }%>		
<%		    if(ht_size==0){%>		
		        <tr>
	  	            <td colspan='10' align="center">등록된 데이타가 없습니다.</td>
    	        </tr>		
<%		    }%>		
            </table>
        </td>
    </tr>	
    <tr>
	    <td></td>
    </tr>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서 발행 일시중지 등록</span></td>
    </tr>
    <tr>
	    <td valign=top><iframe src="fee_scd_u_stop.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&seq=<%=seq%>&mode=<%=mode%>" name="stopreg" width="100%" height="350" cellpadding="0" cellspacing="0" border="0" frameborder="0" topmargin=0 noresize></iframe></td>
    </tr>	
</table>
</form>
</body>
</html>
