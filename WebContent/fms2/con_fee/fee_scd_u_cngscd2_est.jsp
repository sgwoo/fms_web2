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
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	int idx = request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode   		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	
	Vector ht = af_db.getFeeScdCngEst(l_cd, rent_st);
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	
	for(int i = 0 ; i < 1 ; i++){
		fee_scd = (FeeScdBean)ht.elementAt(i);
	}
	
	Hashtable rtn = af_db.getFeeRtnCase(m_id, l_cd, rent_st, rent_seq);
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//대여스케줄 변경
	function cng_schedule()
	{
		var fm = document.form1;

		if(fm.fee_tm.value 	== '')			{	alert('변경회차를 선택하십시오'); 		fm.fee_tm.focus(); 		return; }				
		if(fm.use_start_dt.value 	== '')		{	alert('사용기간을 입력하십시오'); 		fm.use_start_dt.focus(); 	return; }
		if(fm.use_end_dt.value 	== '')			{	alert('사용기간을 입력하십시오'); 		fm.use_end_dt.focus(); 		return; }		
		
		var a_dt 	= '';
		var b_dt 	= '';
		var cha_mon = 0;
		var a_dt_nm = '';

		a_dt 	= fm.use_start_dt.value;
		b_dt 	= fm.use_end_dt.value;			
		a_dt_nm = '사용기간이';
		
		if(a_dt != ''){
			cha_mon = getRentTime('m', a_dt, b_dt);
			if(cha_mon > 2){ 
				if(!confirm('입력한  '+a_dt_nm+' 두달이상 차이납니다.\n\n스케줄을 변경하시겠습니까?'))			
					return;
			}
			if(cha_mon <  -2){ 
				if(!confirm('입력한 '+a_dt_nm+' -두달이상 차이납니다.\n\n스케줄을 변경하시겠습니까?'))			
					return;
			}
		}
		
		if(fm.c_all[1].checked == true && fm.s_max_tm.value == ''){ alert('적용마지막 회차를 입력하세요.'); return; }
				
		if(confirm('스케줄를 변경 하시겠습니까?'))
		{							
			fm.action = './fee_scd_u_cngscd2_est_a.jsp';
			fm.target = 'i_no';
			fm.target = 'CNGSCD2';
			fm.submit();
		}
	}		
	function set_before(){
		var fm = document.form1;
		var values = fm.fee_tm.options[fm.fee_tm.selectedIndex].value;
		var value_split = values.split(",");
		fm.r_fee_tm.value 		= value_split[0];		
		fm.req_dt.value 		= ChangeDate(value_split[1]);
		fm.tax_out_dt.value 		= ChangeDate(value_split[2]);
		fm.fee_est_dt.value 		= ChangeDate(value_split[3]);
		fm.use_start_dt.value 		= ChangeDate(value_split[4]);
		fm.use_end_dt.value 		= ChangeDate(value_split[5]);		
	}	
	
	//대여일수 구하기
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}				
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='rent_seq' value='<%=rent_seq%>'>
<input type='hidden' name='cng_st' value='<%=cng_st%>'>
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
<input type='hidden' name='scd_size' value='<%=ht_size%>'>
<input type='hidden' name='r_fee_tm' value='<%=fee_scd.getFee_tm()%>'>
  <input type='hidden' name="doc_no" 			value="<%=doc_no%>">
  <input type='hidden' name="mode" 			value="<%=mode%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > 대여료스케줄관리 > <span class=style5>사용기간 변경</span></span></td>
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
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='14%' class='title'>계약번호</td>
                    <td width='20%'>
    			    &nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='14%' class='title'>상호</td>
                    <td>
    			    &nbsp;<%=base.get("FIRM_NM")%></td>
                </tr>
		        <%if(!String.valueOf(base.get("R_SITE")).equals("")){%>
                <tr>
                    <td class='title'>사용본거지</td>
                    <td colspan="3">&nbsp;<%=base.get("R_SITE_NM")%></td>
                </tr>	
		        <%}%>	   
                <tr>
                    <td class='title'>차량번호</td>
                    <td>
    			    &nbsp;<font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td>
			        &nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr>
                    <td class='title'> 대여방식 </td>
                    <td>
			        &nbsp;<%=base.get("RENT_WAY")%></td>
                    <td class='title'>CMS</td>
                    <td>
				    &nbsp;<%if(!cms.getCms_bank().equals("")){%>
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
                    <td>
    			    &nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td class='title'>관리담당자</td>
                    <td>
    			    &nbsp;<%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>		   
            </table>
	    </td>
	</tr>

    <tr> 
        <td class=h></td>
    </tr>  			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신차대여</span></td>	
	</tr>	  

    <tr> 
        <td class=line2></td>
    </tr>				
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <%		for(int i = 0 ; i < 1 ; i++){
    				fee_scd = (FeeScdBean)ht.elementAt(i);
    			}%>
                <tr> 
                    <td width=14% class='title'>변경회차</td>
                    <td> 
                        &nbsp;<%	if(ht_size > 0){%>
                        <select name='fee_tm' onchange="javascript:set_before()">
                        <%		for(int i = 0 ; i < ht_size ; i++){
    								FeeScdBean bean = (FeeScdBean)ht.elementAt(i);
    								if(i==0){
    									fee_scd = bean;
    								}%>
                        <option value='<%=bean.getFee_tm()%>,<%=bean.getReq_dt()%>,<%=bean.getTax_out_dt()%>,<%=bean.getFee_est_dt()%>,<%=bean.getUse_s_dt()%>,<%=bean.getUse_e_dt()%>'><%=AddUtil.parseInt(bean.getFee_tm())%></option>
                        <%		}%>
                        </select>
                        회 
                        <br>	
							&nbsp;
                        <input type="radio" name="c_all" value="Y">
                        선택회차부터 모든 회차 적용 
                        <br>
							  &nbsp;
							    <input type="radio" name="c_all" value="M">
							  선택회차부터 <b><input type='text' name='s_max_tm' value='' size='2' class='num'>회차까지</b> 적용
                        <%	}else{%>
                        선택가능한 회차가 없습니다. 
                        <%	}%>
                    </td>
                </tr>
                <tr> 
                    <td width=100 class='title' rowspan='2'>사용기간</td>
                    <td>&nbsp;<input type='text' name='use_start_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getUse_s_dt())%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    ~ 
                    <input type='text' name='use_end_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getUse_e_dt())%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;<input type="checkbox" name="maxday_yn1" value="Y"> 말일
                        <font color=red>&nbsp;(기간 종료일자가 말일일때 선택하세요.)</font></td>
                </tr>
                <tr>
                    <td class='title' rowspan='2'>발행일자</td>
                    <td>&nbsp;
                    <input type='text' name='req_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getReq_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate2(this.value);'></td>
                </tr>
                <tr>
                    <td>&nbsp;<input type="checkbox" name="maxday_yn2" value="Y"> 말일
                        <font color=red>&nbsp;(발행일자가 말일일때 선택하세요.)</font></td>
                </tr>
                <tr>
                    <td class='title' rowspan='2'>세금일자</td>
                    <td>&nbsp;
                    <input type='text' name='tax_out_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getTax_out_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate2(this.value);'></td>
                </tr>
                <tr>
                    <td>&nbsp;<input type="checkbox" name="maxday_yn3" value="Y"> 말일
                        <font color=red>&nbsp;(세금일자가 말일일때 선택하세요.)</font></td>
                </tr>
                <tr>
                    <td class='title' rowspan='2'>입금예정일</td>
                    <td>&nbsp;
                    <input type='text' name='fee_est_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getFee_est_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate2(this.value);'></td>
                </tr>                
                <tr>
                    <td>&nbsp;<input type="checkbox" name="maxday_yn4" value="Y"> 말일
                        <font color=red>&nbsp;(입금예정일이 말일일때 선택하세요.)</font></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align='right'>&nbsp;</td>
    </tr>		
	<tr>
	    <td align="center">
        <a href="javascript:cng_schedule();"><img src=/acar/images/center/button_ch.gif border=0 align=absmiddle></a>
        &nbsp;&nbsp;
        <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>	
	    </td>
	</tr>	
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
