<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.ext.*, acar.car_mst.*, acar.pay_mng.*"%>
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
	
	Vector grts = ae_db.getExtScd(m_id, l_cd, "0");
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
	
	int total_amt 	= 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name="depoSlipListForm" method="get">
	<input type="hidden" name="depoSlippubCode" >
	<input type="hidden" name="docType" >
	<input type="hidden" name="userType" >
</form>
<form name='form1' method='post'>


<table border="0" cellspacing="0" cellpadding="0" width=100%>
<%if(grt_size>0){%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증금 수금스케줄</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10%  class='title'>회차</td>
                    <td width=15% class='title'>공급가</td>
                    <td width=15% class='title'>부가세</td>
                    <td width=15% class='title'>합계</td>
                    <td width=15% class='title'>입금예정일</td>
                    <td width=15% class='title'>입금일</td>
                    <td width=15% class='title'>입금액</td>
                </tr>
          <%		for(int i = 0 ; i < grt_size ; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			total_amt 	= total_amt + grt.getExt_pay_amt();
			if(!grt.getExt_pay_dt().equals("")){%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'><input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
        			원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='<%=Util.parseDecimal(grt.getExt_pay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
          <%			}else{%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'> <input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
                      원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>			
                </tr>
          <%			}
		}%>
                <tr> 
                    <td class="title" colspan="6">합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원</td>													
                </tr>					  		
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>   
<%}%>	 
	<%	grts = ae_db.getExtScd(m_id, l_cd, "2");
		grt_size = grts.size();
		total_amt 	= 0;	%>
<%if(grt_size>0){%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>개시대여료 수금스케줄</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10%  class='title'>회차</td>
                    <td width=15% class='title'>공급가</td>
                    <td width=15% class='title'>부가세</td>
                    <td width=15% class='title'>합계</td>
                    <td width=15% class='title'>입금예정일</td>
                    <td width=15% class='title'>입금일</td>
                    <td width=15% class='title'>입금액</td>
                </tr>
          <%		for(int i = 0 ; i < grt_size ; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			total_amt 	= total_amt + grt.getExt_pay_amt();
			if(!grt.getExt_pay_dt().equals("")){%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'><input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
        			원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='<%=Util.parseDecimal(grt.getExt_pay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
          <%			}else{%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'> <input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
                      원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>			
                </tr>
          <%			}
		}%>
                <tr> 
                    <td class="title" colspan="6">합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원</td>													
                </tr>					  		
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>   
<%}%>	 
	<%	grts = ae_db.getExtScd(m_id, l_cd, "1");
		grt_size = grts.size();
		total_amt 	= 0;	%>
<%if(grt_size>0){%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선납금 수금스케줄</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10%  class='title'>회차</td>
                    <td width=15% class='title'>공급가</td>
                    <td width=15% class='title'>부가세</td>
                    <td width=15% class='title'>합계</td>
                    <td width=15% class='title'>입금예정일</td>
                    <td width=15% class='title'>입금일</td>
                    <td width=15% class='title'>입금액</td>
                </tr>
          <%		for(int i = 0 ; i < grt_size ; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			total_amt 	= total_amt + grt.getExt_pay_amt();
			if(!grt.getExt_pay_dt().equals("")){%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'><input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
        			원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='<%=Util.parseDecimal(grt.getExt_pay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
          <%			}else{%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'> <input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
                      원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>			
                </tr>
          <%			}
		}%>
                <tr> 
                    <td class="title" colspan="6">합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원</td>													
                </tr>					  		
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
<%}%>	 
	<%	grts = ae_db.getExtScd(m_id, l_cd, "5");
		grt_size = grts.size();
		total_amt 	= 0;	%>
<%if(grt_size>0){%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>승계수수료 수금스케줄</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10%  class='title'>회차</td>
                    <td width=15% class='title'>공급가</td>
                    <td width=15% class='title'>부가세</td>
                    <td width=15% class='title'>합계</td>
                    <td width=15% class='title'>입금예정일</td>
                    <td width=15% class='title'>입금일</td>
                    <td width=15% class='title'>입금액</td>
                </tr>
          <%		for(int i = 0 ; i < grt_size ; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			total_amt 	= total_amt + grt.getExt_pay_amt();
			if(!grt.getExt_pay_dt().equals("")){%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'><input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
        			원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='<%=Util.parseDecimal(grt.getExt_pay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
          <%			}else{%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'> <input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
                      원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>			
                </tr>
          <%			}
		}%>
                <tr> 
                    <td class="title" colspan="6">합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원</td>													
                </tr>					  		
            </table>
        </td>
    </tr>	
<%}%>	 	
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td align=right><a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>    		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
<script language='javascript'>
<!--
//-->
</script>  
</body>
</html>