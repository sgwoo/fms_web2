<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*,acar.ext.*, acar.car_mst.*, acar.pay_mng.*, acar.cls.*, acar.credit.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
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
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String r_st 	= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
	
	//기본정보
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	r_st = String.valueOf(fee.get("RENT_ST"));
	String brch_id = String.valueOf(fee.get("BRCH_ID"));
	
	if(r_st.equals(""))	r_st = "1";
	
	Vector grts = ae_db.getExtScd(m_id, l_cd, "7");
	int grt_size = grts.size();
	
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//신차대여정보
	ContFeeBean fee2 = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(m_id, l_cd);
	
	//마지막대여정보
	ContFeeBean max_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
		
	//계약기본정보
	ContBaseBean c_base = a_db.getCont(m_id, l_cd);
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(m_id, c_base.getReg_dt());
	//계약승계 혹은 차종변경일때 승계계약 해지내용
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//리스트 가기
	function go_to_list()
	{
		var fm 		= document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id	= fm.br_id.value;
		var user_id = fm.user_id.value;
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
		var idx 	= fm.idx.value;				
		location = "/fms2/con_ecar/ecar_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&idx="+idx;
	}

	
	//수정
	function update_grt(rent_st, p_st, tm, idx)
	{
		var fm = document.form1;
		fm.p_st.value = p_st;
		fm.tm.value = tm;
		if(p_st == '7'){
			if(!confirm('구매보조금을 수정하시겠습니까?'))
			{
				return;
			}
			if(fm.grt_size.value == '1'){
				fm.est_dt.value = fm.t_grt_est_dt.value;
				fm.pay_dt.value = fm.t_grt_pay_dt.value;
				fm.pay_amt.value = parseDigit(fm.t_grt_pay_amt.value);				
			}else{
				fm.est_dt.value = fm.t_grt_est_dt[idx].value;
				fm.pay_dt.value = fm.t_grt_pay_dt[idx].value;
				fm.pay_amt.value = parseDigit(fm.t_grt_pay_amt[idx].value);								
			}			
		}
		
		fm.rent_st.value = rent_st;
		fm.action = '/fms2/con_ecar/mod_scd_u.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	


	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">

	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
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
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='client_id' value='<%=fee.get("CLIENT_ID")%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='grt_size' value='<%=grt_size%>'>
<input type='hidden' name='p_st' value=''>
<input type='hidden' name='rent_st' value=''>
<input type='hidden' name='tm' value=''>
<input type='hidden' name='pay_dt' value=''>
<input type='hidden' name='est_dt' value=''>
<input type='hidden' name='ext_dt' value=''>
<input type='hidden' name='pay_amt' value=''>
<input type='hidden' name='s_amt' value=''>
<input type='hidden' name='v_amt' value=''>
<input type='hidden' name='est_amt' value=''>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>선수금 관리</span></span></td>
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>[계약승계] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("FIRM_NM")%>, 승계일자 : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%>, 해지일자 : <%=begin.get("CLS_DT")%> <%}%>
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>[차종변경] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, 변경일자 : <%=begin.get("CLS_DT")%><%}%>            	    
					
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>[계약승계] 승계계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 승계일자 : <%if(String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("")){%><%=cng_cont.get("CLS_DT")%><%}else{%><%=cng_cont.get("RENT_SUC_DT")%><%}%> <%if(!String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("") && !String.valueOf(cng_cont.get("RENT_SUC_DT")).equals(String.valueOf(cng_cont.get("CLS_DT")))){%>, 해지일자 : <%=cng_cont.get("CLS_DT")%><%}%> <%}%>
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>[차종변경] 변경계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 변경일자 : <%=cng_cont.get("CLS_DT")%> <%}%>					
					</font>&nbsp;
					</td>			
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align="right">	  
		<a href="javascript:go_to_list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
		<a href="javascript:history.go(-1);"><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% class='title'>계약번호</td>
                    <td width=12%>&nbsp;&nbsp;<%=fee.get("RENT_L_CD")%></td>
                    <td width=10% class='title'>상호</td>
                    <td width=26%>&nbsp;&nbsp;<a href="javascript:view_client('<%=m_id%>','<%=l_cd%>','1')"><%=fee.get("FIRM_NM")%></a></td>
                    <td width=10% class='title'>계약자</td>
                    <td width=11%>&nbsp;&nbsp;<%=fee.get("CLIENT_NM")%></td>
                    <td width=10% class='title'>최초영업자</td>
                    <td width=11%>&nbsp;&nbsp;<%=c_db.getNameById(String.valueOf(fee.get("BUS_ID")),"USER")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td><%=mst.getCar_nm()+" "+mst.getCar_name()%></td>
                            </tr>
                        </table>
                    </td>
                    <td class='title'> 대여방식 </td>
                    <td>&nbsp;<%if(max_fee.getRent_way().equals("1")){%>
                      일반식 
                      <%}else if(max_fee.getRent_way().equals("2")){%>
                      맞춤식 
                      <%}else{%>
                      기본형 
                      <%}%>
                    </td>
                    <td class='title'>대여기간</td>
                    <td>&nbsp;<%if(r_st.equals("1")){%>
                      <%=fee.get("CON_MON")%>
                      <%}else{%>
                      연장<%=max_fee.getCon_mon()%>
                      <%}%>
                      개월</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td align='right'></td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>구매보조금</span></td>
        <td align='right'></td>
    </tr>
    <%	if(grt_size > 0){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=5%  class='title'>구분</td>
                    <td width=5%  class='title'>회차</td>
                    <td width=8% class='title'>공급가</td>
                    <td width=5% class='title'>부가세</td>
                    <td width=13% class='title'>합계</td>
                    <td width=10% class='title'>약정일</td>
                    <td width=10% class='title'>입금일</td>
                    <td width=10% class='title'>입금액</td>                    
                    <td width=12% class='title'>처리</td>                    
                </tr>
          <%		for(int i = 0 ; i < grt_size ; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			if(!grt.getExt_pay_dt().equals("")){%>
                <tr> 
                    <td align='center'><%if(grt.getRent_st().equals("1")){%>신규<%}else{%><%=AddUtil.parseInt(grt.getRent_st())-1%>차연장<%}%></td>				
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'><input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
        			원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='text' maxlength='11' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='num' maxlength='10' value='<%=Util.parseDecimal(grt.getExt_pay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                    <td align='center'>
                      <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:update_grt('<%=grt.getRent_st()%>', '0', '<%=grt.getExt_tm()%>', '<%=i%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      <%	}%>
        			</td>
                </tr>
          <%			}else{%>
                <tr> 
                    <td align='center'><%if(grt.getRent_st().equals("1")){%>신규<%}else{%><%=AddUtil.parseInt(grt.getRent_st())-1%>차연장<%}%></td>								
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'> <input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
                      원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='text' maxlength='11' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='num' maxlength='10' value='<%//=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                    </td>
                    <td align='center'> 
                      <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:update_grt('<%=grt.getRent_st()%>', '7', '<%=grt.getExt_tm()%>', '<%=i%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>&nbsp; 
                      <%	}%>
                    </td>
                </tr>
          <%			}
		}%>
            </table>
        </td>
    </tr>
	
	<%       %>
    <%	}else{%>
    <tr> 
        <td colspan="2">보증금내역이 없습니다</td>
    </tr>
    <%	}%>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
<script language='javascript'>
<!--

	var fm = document.form1;

	//바로가기
	var s_fm = parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = "";		
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";

//-->
</script>  
</body>
</html>