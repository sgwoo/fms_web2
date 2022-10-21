<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	int idx 	= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String client_id    = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String s_fee_est_dt = request.getParameter("s_fee_est_dt")==null?"":request.getParameter("s_fee_est_dt");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
	
	Vector ht = af_db.getFeeScdCng(l_cd, "", "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//승계후계약
	ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cng_cont.get("RENT_MNG_ID")), String.valueOf(cng_cont.get("RENT_L_CD")));
	
	
	//승계전 대여정보
	ContFeeBean b_fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	//승계후 대여정보
	ContFeeBean a_fee = a_db.getContFeeNew(String.valueOf(cng_cont.get("RENT_MNG_ID")), String.valueOf(cng_cont.get("RENT_L_CD")), rent_st);
	
	if(cont_etc.getRent_mng_id().equals("")){
		cont_etc.setRent_mng_id	(m_id);
		cont_etc.setRent_l_cd	(l_cd);
	}	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//대여스케줄 이관
	function cng_schedule()
	{
		var fm = document.form1;
	
		if(confirm('스케줄를 이관 하시겠습니까?'))
		{							
			fm.action = 'fee_scd_u_cngscd4_a.jsp';
			//fm.target = 'i_no';
			fm.submit();
		}
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method="post">
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
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='rent_suc_m_id' value='<%=cont_etc.getRent_mng_id()%>'>
<input type='hidden' name='rent_suc_l_cd' value='<%=cont_etc.getRent_l_cd()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>대여료 스케줄 이관</span></span></td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>승계일자</td>
                    <td>&nbsp;
					  <%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%>
					  <input type='hidden' name='rent_suc_dt' value='<%=cont_etc.getRent_suc_dt()%>'>
                    </td>
                </tr>				
    		</table>
	    </td>
    </tr>	
    <tr>
	    <td class=h></td>
	</tr> 			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 스케줄 이관</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>				
    <tr> 
        <td colspan=2 class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>이관회차</td>
                    <td>&nbsp;
        			  <%	if(ht_size > 0){%>
        						<select name='fee_tm'>
        						   <option value="">선택</option>
        					<%		for(int i = 0 ; i < ht_size ; i++){
        								FeeScdBean bean = (FeeScdBean)ht.elementAt(i);
        								if(i==0){
        									fee_scd = bean;
        								}%>
        							<option value='<%=bean.getFee_tm()%>' <%if(cont_etc.getRent_suc_fee_tm().equals(bean.getFee_tm()))%>selected<%%>>[<%=AddUtil.addZero(bean.getFee_tm())%>회차] <%=AddUtil.ChangeDate2(bean.getFee_est_dt())%> <%if(bean.getRc_yn().equals("0")){%>미입금<%}else{%>입금<%}%></option>
        					<%		}%>
								  <option value="9999">이관회차없음</option>
        						</select> 회
                		      &nbsp;(선택회차부터 모든 회차 이관)
							  
							  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;							  
							  <input type="checkbox" name="tax_cng_yn" value="Y" checked> 기발행 계산서가 있을 경우 승계하는 계약번호로 변경
							  
        					<%	}else{%>
        						선택가능한 회차가 없습니다.
        					<%	}%>	        					        						  
                    </td>
                </tr>
                <tr>
                    <td width='13%' class='title'>일자계산기준일자</td>
                    <td>&nbsp;
                        <input type="text" name="rent_suc_fee_tm_b_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_fee_tm_b_dt())%>" size="10" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate2(this.value)'>        			          		
                    </td>
                </tr>                
    		</table>
	    </td>
    </tr>	
    <tr>
	    <td class=h></td>
	</tr> 		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증금 승계정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>승계계약</td>
                    <td>&nbsp;
					  보증금 : <%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%> 원, 
						  &nbsp;&nbsp;&nbsp;						  				  
					  승계여부 :  
        			  <select name='o_grt_suc_yn' disabled>
                              <option value=""  <%if(cont_etc.getRent_suc_grt_yn().equals(""))%>selected<%%>>선택</option>
                              <option value="0" <%if(cont_etc.getRent_suc_grt_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(cont_etc.getRent_suc_grt_yn().equals("1"))%>selected<%%>>별도</option>
                            </select>	
                    </td>
                </tr>				
    		</table>
	    </td>
    </tr>	
    <tr>
	    <td class=h></td>
	</tr> 		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금 승계처리</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='20%' class='title'>구분</td>
                    <td width='30%' class='title'>승계전</td>
                    <td width='30%' class='title'>승계후</td>										
                    <td width='20%' class='title'>처리여부</td>															
                </tr>
                <tr>
                    <td class='title'>계약번호</td>				
					<td align="center"><%=b_fee.getRent_l_cd()%></td>				
					<td align="center"><%=a_fee.getRent_l_cd()%></td>									
					<td align="center">-</td>														
                </tr>					
                <tr>
                    <td class='title'>보증금</td>				
					<td align="right"><%=AddUtil.parseDecimal(b_fee.getGrt_amt_s())%>원&nbsp;</td>				
					<td align="right"><%=AddUtil.parseDecimal(a_fee.getGrt_amt_s())%>원&nbsp;</td>									
					<td align="center">
							<select name='grt_suc_yn'>
                              <option value=""  <%if(cont_etc.getRent_suc_grt_yn().equals(""))%>selected<%%>>선택</option>
                              <option value="0" <%if(b_fee.getGrt_amt_s()>0 && a_fee.getGrt_amt_s()>0 && cont_etc.getRent_suc_grt_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(a_fee.getGrt_amt_s()>0 && cont_etc.getRent_suc_grt_yn().equals("1"))%>selected<%%>>별도</option>
                            </select>	</td>														
                </tr>					
                <tr>
                    <td class='title'>선납금</td>				
					<td align="right"><%=AddUtil.parseDecimal(b_fee.getPp_s_amt()+b_fee.getPp_v_amt())%>원&nbsp;<br>(원계약:<%=AddUtil.parseDecimal(cont_etc.getPp_suc_o_amt())%>)&nbsp;</td>				
					<td align="right"><%=AddUtil.parseDecimal(a_fee.getPp_s_amt()+a_fee.getPp_v_amt())%>원&nbsp;<br>(승계계약:<%=AddUtil.parseDecimal(cont_etc.getPp_suc_r_amt())%>)&nbsp;</td>									
					<td align="center">
							<select name='pp_suc_yn'>
                              <option value=""  <%if(cont_etc.getRent_suc_pp_yn().equals(""))%>selected<%%>>선택</option>
                              <option value="0" <%if(cont_etc.getRent_suc_pp_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(cont_etc.getRent_suc_pp_yn().equals("1"))%>selected<%%>>별도</option>
                            </select>	</td>														
                </tr>					
                <tr>
                    <td class='title'>개시대여료</td>				
					<td align="right"><%=AddUtil.parseDecimal(b_fee.getIfee_s_amt()+b_fee.getIfee_v_amt())%>원&nbsp;<br>(원계약:<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_o_amt())%>)&nbsp;</td>				
					<td align="right"><%=AddUtil.parseDecimal(a_fee.getIfee_s_amt()+a_fee.getIfee_v_amt())%>원&nbsp;<br>(승계계약:<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_o_amt())%>)&nbsp;</td>									
					<td align="center">
							<select name='ifee_suc_yn'>
                              <option value=""  <%if(cont_etc.getRent_suc_ifee_yn().equals(""))%>selected<%%>>선택</option>
                              <option value="0" <%if(cont_etc.getRent_suc_ifee_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(cont_etc.getRent_suc_ifee_yn().equals("1"))%>selected<%%>>별도</option>
                            </select>	</td>														
                </tr>		
    		</table>
	    </td>
    </tr>	
                     <input type='hidden' name="pp_s_amt" value="">
					 <input type='hidden' name="pp_v_amt" value="">
					 <input type='hidden' name="ifee_s_amt" value="">
					 <input type='hidden' name="ifee_v_amt" value="">
    <tr>
	    <td class=h></td>
	</tr> 			 	  
	<tr>
	    <td>* 승계여부가 승계면 기존 보증금 스케줄을 연동시키고, 별도면 신규 스케줄이 생성됩니다.</td>
    </tr>	
	<tr>
	    <td>&nbsp;</td>
    </tr>		
	<tr>
	    <td align="center">
            <a href="javascript:cng_schedule();"><img src=/acar/images/center/button_ch.gif border=0 align=absmiddle></a>
      		&nbsp;&nbsp;
      		<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>		
	    </td>
	</tr>	
</table>
</form>
<script language="JavaScript">
<!--
		var fm = document.form1;

		//선납금 숭계관련
		var pp_amt = <%=cont_etc.getPp_suc_r_amt()%>;
		if (pp_amt > 0 ) {
			fm.pp_s_amt.value = sup_amt(pp_amt);
			fm.pp_v_amt.value = pp_amt - toInt(fm.pp_s_amt.value);
		}	

		//개시대여료 숭계관련
		var ifee_amt = <%=cont_etc.getIfee_suc_r_amt()%>;
		if (ifee_amt > 0 ) {
			fm.ifee_s_amt.value = sup_amt(ifee_amt);
			fm.ifee_v_amt.value = ifee_amt - toInt(fm.ifee_s_amt.value);
		}	
					
//-->
</script> 		
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>


