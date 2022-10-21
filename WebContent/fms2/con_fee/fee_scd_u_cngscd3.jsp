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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean cont 	= a_db.getCont(m_id, l_cd);
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	
	Vector ht = af_db.getFeeScdCngNew(l_cd, rent_st, rent_seq, "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	int tae_sum = af_db.getTaeCnt_lcd(l_cd);
	
	if(rent_st.equals("")){ tae_sum = 0; }
	
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
	function cng_schedule3()
	{
		var fm = document.form1;

		if(fm.rtn_yn.checked == true){
			if(fm.r_fee_tm.value 	== '')				{	alert('변경회차를 선택하십시오'); 		fm.fee_tm.focus(); 			return; }				
		}
		
		//분할청구
		var rtn_tm = toInt(fm.rtn_tm.value);			
		var tot_rtn_fee_amt = 0;
		for(i=0; i<rtn_tm; i++){ 
			if(fm.rtn_firm_nm[i].value == ''){ alert(i+1+'번 분할 공급받는자를 선택하십시오.'); return;}
			if(toInt(parseDigit(fm.rtn_fee_amt[i].value)) > 0){ 
				fm.rtn_fee_s_amt[i].value 	= sup_amt(toInt(parseDigit(fm.rtn_fee_amt[i].value)));
				fm.rtn_fee_v_amt[i].value 	= toInt(parseDigit(fm.rtn_fee_amt[i].value)) - toInt(fm.rtn_fee_s_amt[i].value);
			}
		}
		
		if(confirm('스케줄를 변경 하시겠습니까?'))
		{							
			fm.action = './fee_scd_u_cngscd3_a.jsp';
//			fm.target = 'i_no';
			fm.target = 'CNGSCD3';
			fm.submit();
		}
	}		
	function set_before(){
		var fm = document.form1;
		var values = fm.fee_tm.options[fm.fee_tm.selectedIndex].value;
		var value_split = values.split(",");
		fm.r_fee_tm.value 		= value_split[0];		
		fm.f_use_start_dt.value = ChangeDate(value_split[6]);
		fm.f_use_end_dt.value 	= ChangeDate(value_split[7]);
	}	
	
	//분할청구거래처 조회
	function search_client(idx){
		var fm = document.form1;
		window.open("/tax/pop_search/s_client_site.jsp?go_url=fee_scd_u_mkscd&s_kd=1&t_wd="+fm.rtn_firm_nm[idx].value+"&idx="+idx, "ClientSite", "left=100, top=400, width=900, height=300, scrollbars=yes");	
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
<input type='hidden' name='rtn_st' value='Y'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > 대여료스케줄관리 > <span class=style5>대여료 분할</span></span></td>
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
<%	if(rent_st.equals("") && idx==1){%>  
    <tr> 
        <td class=h></td>
    </tr>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고지연 대차대여</span></td>	
	</tr>	
<%	}%>		
<%	if(idx==2){%>  
    <tr> 
        <td class=h></td>
    </tr>  			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(rent_st.equals("1")){%>신차<%}else{%><%=AddUtil.parseInt(rent_st)-1%>차 연장<%}%>대여</span></td>	
	</tr>	  
<%	}%>	
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
                        <option value='<%=bean.getFee_tm()%>,<%=bean.getFee_s_amt()%>,<%=bean.getFee_v_amt()%>,<%=bean.getReq_dt()%>,<%=bean.getTax_out_dt()%>,<%=bean.getFee_est_dt()%>,<%=bean.getUse_s_dt()%>,<%=bean.getUse_e_dt()%>'><%=AddUtil.parseInt(bean.getFee_tm())%></option>
                        <%		}%>
                        </select>
                        회 
                        <input type="checkbox" name="c_all" value="Y">
                        선택회차부터 모든 회차 적용 
                        <%	}else{%>
                        선택가능한 회차가 없습니다. 
                        <%	}%>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align='right'>&nbsp;</td>
    </tr>		
    <tr> 
        <td class=line2></td>
    </tr>				
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='14%' class='title'>대여료분할</td>
                    <td colspan="3">
                      &nbsp;<input type="checkbox" name="rtn_yn" value="Y">
                        위 조건으로 대여료 스케줄 분할 
                        <%if(fee.getPp_chk().equals("0")){%>&nbsp;<font color=red>* 선납금 매월균등발행 (정상요금대여료는 분할하지 않음)</font><%}%>
                    </td>
                </tr>
                <tr>
                    <td width='14%' class='title'>분할갯수</td>
                    <td colspan="3">
                      &nbsp;<select name='rtn_tm' onchange="javascript:display_rtn2()">
                        <%	for(int i=2; i<=5 ; i++){%>
                        <option value='<%=i%>'><%=i%></option>개
                        <% } %>
                      </select></td>
                </tr>
    		  <%String firm_nm 		= String.valueOf(base.get("FIRM_NM"));
    			String client_id 	= String.valueOf(base.get("CLIENT_ID"));
    		  	String site_id 		= "";
    		  	if(cont.getTax_type().equals("2")){
    				firm_nm 		= String.valueOf(base.get("R_SITE"));
    				site_id 		= String.valueOf(base.get("R_SITE_SEQ"));
    			}%>
                <tr>
                    <td class='title'>연번</td>
                    <td width='20%' class='title'>구분</td>
                    <td width='40%' class='title'>공급받는자</td>
        			<td width='25%' class='title'>청구금액</td>
                </tr>			
                <tr>
                    <td class='title'>1</td>
                    <td align="center">
        			  <select name='rtn_type'>
                        <option value='0'>대여료</option>
                      </select>
        			  </td> 
                    <td>&nbsp;
        			  <input type='text' size='30' name='rtn_firm_nm' value='<%=firm_nm%>' class='text' readonly>
        			  </td>
        			  <td width='350' align="center">
                      <input type='text' name='rtn_fee_amt' value='0' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
        			  <input type='hidden' name='rtn_fee_s_amt' value='0'>
        			  <input type='hidden' name='rtn_fee_v_amt' value='0'>		
        			  <input type='hidden' name='rtn_client_id' value='<%=client_id%>'>
        			  <input type='hidden' name='rtn_site_id' value='<%=site_id%>'></td>
                </tr>
    		    <%	for(int i=2; i<=5 ; i++){%>
                <tr tr id=tr_rtn<%=i%> style="display:<%if(i==2){%>''<%}else{%>none<%}%>">
                    <td class='title'><%=i%></td>
                     <td align="center">
        			  <select name='rtn_type'>
                        <option value='0'>대여료</option>
                        <option value='4' <%if(fee.getPp_chk().equals("0")){%>selected<%}%>>선납금균등발행</option>
                      </select>
        			  </td>   
                    <td>&nbsp;
        			  <input type='text' size='30' name='rtn_firm_nm' value='<%if(i==2 && fee.getPp_chk().equals("0")){%><%=firm_nm%><%}%>' class='text'>
        			  <span class="b"><a href="javascript:search_client(<%=i-1%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
        			  </td>
        			  <td align="center">
        			  <input type='text' name='rtn_fee_amt' value='0' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원
        			  <input type='hidden' name='rtn_fee_s_amt' value='0'>
        			  <input type='hidden' name='rtn_fee_v_amt' value='0'>
        			  <input type='hidden' name='rtn_client_id' value='<%if(i==2 && fee.getPp_chk().equals("0")){%><%=client_id%><%}%>'>
        			  <input type='hidden' name='rtn_site_id' value='<%if(i==2 && fee.getPp_chk().equals("0")){%><%=site_id%><%}%>'>
        			</td>
                </tr>
    		  <% } %>
            </table>
	    </td>
    </tr>	
	<tr>
	    <td align='right'>&nbsp;</td>
    </tr>		
	<tr>
	    <td align="center">
        <a href="javascript:cng_schedule3();"><img src=/acar/images/center/button_ch.gif border=0 align=absmiddle></a>
        &nbsp;&nbsp;
        <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>	
	    </td>
	</tr>	
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
