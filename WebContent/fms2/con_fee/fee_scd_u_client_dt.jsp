<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
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
	String asc 		= request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String s_fee_est_dt = request.getParameter("s_fee_est_dt")==null?"":request.getParameter("s_fee_est_dt");
	
	//발행작업스케줄
	Vector fee_scd = ScdMngDb.getFeeScdClient(client_id, s_fee_est_dt);
	int fee_scd_size = fee_scd.size();
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
	
		if(confirm('스케줄를 변경 하시겠습니까?'))
		{							
			fm.action = './fee_scd_u_client_dt_a.jsp';
			fm.target = 'i_no';
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
<input type='hidden' name='s_fee_est_dt' value='<%=s_fee_est_dt%>'>
<input type='hidden' name='vt_size' value='<%=fee_scd_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
<!--신차(연장)대여-->
<%		if(fee_scd_size>0){%>  
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>발행예정일 확인</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  
    <tr>
        <td colspan=2 class=line2></td>
    </tR>			
	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td class='title'>연번</td>				
                    <td class='title'>차량번호</td>
                    <td class='title'>회차</td>
                    <td class='title'>분할</td>
                    <td class='title'>지점</td>					
                    <td colspan="2" class='title'>사용기간</td>
                    <td class='title'>월대여료</td>
                    <td class='title'>입금</td>
                    <td class='title'>발행예정일</td>
                    <td class='title'>세금일자</td>
                    <td class='title'>입금예정일</td>
                    <td class='title'>거래명세서<br>발급일자</td>
                    <td class='title'>계산서<br>발행일자</td>
                </tr>
        <%			for(int j = 0 ; j < fee_scd_size ; j++){
        				Hashtable ht = (Hashtable)fee_scd.elementAt(j);%>
                <tr>
                    <td width="5%" align="center"  ><%=j+1%></td>				
                    <td width="10%" align="center"><%=ht.get("CAR_NO")%></td>
                    <td width="4%" align="center"><%=ht.get("FEE_TM")%>
					<input type='hidden' name='c_rent_mng_id' value='<%=ht.get("RENT_MNG_ID")%>'>
					<input type='hidden' name='c_rent_l_cd' 	value='<%=ht.get("RENT_L_CD")%>'>
					<input type='hidden' name='c_rent_st'    	value='<%=ht.get("RENT_ST")%>'>
					<input type='hidden' name='c_rent_seq' 	value='<%=ht.get("RENT_SEQ")%>'>
					<input type='hidden' name='c_fee_tm' 		value='<%=ht.get("FEE_TM")%>'>
					<input type='hidden' name='c_tm_st1' 		value='<%=ht.get("TM_ST1")%>'>
					<input type='hidden' name='c_tm_st2' 		value='<%=ht.get("TM_ST2")%>'>
					</td>
                    <td width="4%" align="center"><%=ht.get("RENT_SEQ")%></td>					
                    <td width="4%" align="center"><%=ht.get("R_SITE")%></td>										
                    <td width="9%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="9%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td width="9%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;&nbsp;</td>
                    <td width="4%" align="center"><%	if(String.valueOf(ht.get("RC_YN")).equals("0")) 		out.println("N");
                     				 				else if(String.valueOf(ht.get("RC_YN")).equals("1"))   	out.println("Y");%>
                    </td>
                    <td width="9%" align="center" ><input type='text' name='c_req_dt' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%>' size='12' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td width="9%" align="center" ><input type='text' name='c_tax_out_dt' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%>' size='12' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td width="8%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                    <td width="8%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%></td>
                    <td width="8%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>
                </tr>
<%			}%>

            </table>
	    </td>
    </tr>
<%		}%> 
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="14%" class='title'>변경사유</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="100" rows="3" class=default style='IME-MODE: active'></textarea>
                    </td>
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
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>


