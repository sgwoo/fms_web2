<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.user_mng.*, acar.estimate_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//보험관리번호
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode = request.getParameter("mode")==null?"7":request.getParameter("mode");
	String cha_amt = request.getParameter("cha_amt")==null?"":request.getParameter("cha_amt");
	
	String update_yn = request.getParameter("update_yn")==null?"":request.getParameter("update_yn");
	
	if(!mode.equals("3") && !mode.equals("pay")) mode = "7";
	
	InsDatabase ai_db = InsDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();

	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//보험정보
	InsurBean ins = ai_db.getInsCase(c_id, ins_st);
	
	
	//기간비용
	Vector costs = ai_db.getPrecosts(c_id, ins_st, "2");
	int cost_size = costs.size();
	
	int total_amt = 0;
	
	//보험스케줄
	Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
	int ins_scd_size = ins_scd.size();	
	
	//해지보험정보
	InsurClsBean cls = ai_db.getInsurClsCase(c_id, ins_st);
	
	int total_amt2 = 0;
	int total_amt3 = 0;
	
	int chk_amt1 = 0;
	int chk_amt2 = 0;
	int chk_amt3 = 0;
	
	//변수
	String var1 = e_db.getEstiSikVarCase("1", "", "ins_modify_dt");
	String var2 = e_db.getEstiSikVarCase("1", "", "ins_modify_mon");
	
	if(update_yn.equals("")){
	  	String modify_deadline = c_db.addMonth(ins.getIns_exp_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
	  	
		if(!cls.getReq_dt().equals("")){
			modify_deadline = c_db.addMonth(cls.getReq_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;			
		}
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) == 20220325) modify_deadline = "20220425";
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
			update_yn = "N";
		}
		
	}	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//기간비용수정하기
	function save(cmd, idx){	
		var fm = document.form1;	
		
		if(fm.ins_st.value == ''){ alert("상단을 먼저 등록하십시오."); return; }
		
		if(idx != ''){
			if(<%=cost_size%> > 0){
				if(fm.cost_size.value == '1'){
					fm.r_cost_tm.value 	= fm.cost_tm.value;
					fm.r_cost_ym.value 	= fm.cost_ym.value;			
					fm.r_cost_day.value = fm.cost_day.value;
					fm.r_cost_amt.value = fm.cost_amt.value;			
					fm.r_rest_day.value = fm.rest_day.value;
					fm.r_rest_amt.value = fm.rest_amt.value;
				}else{
					fm.r_cost_tm.value 	= fm.cost_tm[idx].value;
					fm.r_cost_ym.value 	= fm.cost_ym[idx].value;			
					fm.r_cost_day.value = fm.cost_day[idx].value;
					fm.r_cost_amt.value = fm.cost_amt[idx].value;						
					fm.r_rest_day.value = fm.rest_day[idx].value;
					fm.r_rest_amt.value = fm.rest_amt[idx].value;		
				}
			}
		}
		
		if(!confirm('처리하시겠습니까?')){	return;	}
		
		if(cmd=='d_next'){
			if(!confirm('선택한 회차 이후로 모두 삭제합니다. 처리하시겠습니까?')){	return;	}
		}
		
		fm.cmd.value = cmd;
		
				
		fm.target = "i_no";
		fm.action = "ins_u_a.jsp";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="ins_u_a.jsp" name="form1">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='gubun0' value='<%=gubun0%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' value='<%=gubun4%>'>
	<input type='hidden' name='gubun5' value='<%=gubun5%>'>
	<input type='hidden' name='gubun6' value='<%=gubun6%>'>
	<input type='hidden' name='gubun7' value='<%=gubun7%>'>
	<input type='hidden' name='brch_id' value='<%=brch_id%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='s_kd' value='<%=s_kd%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	<input type='hidden' name='sort' value='<%=sort%>'>
	<input type='hidden' name='asc' value='<%=asc%>'>
	<input type="hidden" name="idx" value="<%=idx%>">
	<input type="hidden" name="s_st" value="<%=s_st%>">
	<input type='hidden' name="go_url" value='<%=go_url%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='ins_st' value='<%=ins_st%>'>
    <input type='hidden' name='cha_amt' value='<%=cha_amt%>'>	
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='cost_size' value='<%=cost_size%>'>		
    <input type='hidden' name='cmd' value=''>	
    <input type='hidden' name='r_ins_tm' value=''>
    <input type='hidden' name='r_ins_tm2' value=''>	
    <input type='hidden' name='r_ins_est_dt' value=''>
    <input type='hidden' name='r_ins_est_dt2' value=''>	
    <input type='hidden' name='r_pay_amt' value=''>
    <input type='hidden' name='r_pay_dt' value=''>	
    <input type='hidden' name='r_cost_tm' value=''>
    <input type='hidden' name='r_cost_ym' value=''>	
    <input type='hidden' name='r_cost_day' value=''>
    <input type='hidden' name='r_cost_amt' value=''>	
    <input type='hidden' name='r_rest_day' value=''>
    <input type='hidden' name='r_rest_amt' value=''>
	

    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기간비용</span> : <%=c_id%> <%=ins_st%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width="100%">
                <tr> 
                    <td class=title width=5%>회차</td>
                    <td class=title width=15%>년월</td>
                    <td class=title width=10%>일수</td>
                    <td class=title width=15%>비용금액</td>			
                    <td class=title width=10%>잔여일수</td>
                    <td class=title width=15%>선급잔액</td>
                    <td class=title width=30%>처리</td>
                </tr>
          <%	for(int i = 0 ; i < cost_size ; i++){
					Hashtable ht = (Hashtable)costs.elementAt(i);
					Hashtable ht2 = new Hashtable();
					
					if(i>0) ht2 = (Hashtable)costs.elementAt(i-1);
					int cng_amt = Util.parseInt(String.valueOf(ht.get("COST_AMT")))+Util.parseInt(String.valueOf(ht.get("REST_AMT")))-Util.parseInt(String.valueOf(ht2.get("REST_AMT")));%>
                <tr align="center"> 
                    <td><%=i+1%> 
                      <input type='hidden' name='cost_tm' value='<%=ht.get("COST_TM")%>'>
                    </td>
                    <td>
                      <input type='text' size='10' name='cost_ym' class='text' value='<%=ht.get("COST_YM")%>'>			
                      </td>
                    <td>
                      <input type='text' size='3' name='cost_day' class='num' value='<%=ht.get("COST_DAY")%>'>
                    </td>
                    <td>
                      <input type='text' size='10' name='cost_amt' class='num' value='<%=Util.parseDecimal(String.valueOf(ht.get("COST_AMT")))%>' onBlur='javascript:this.value=parseDecimal(this.value)'>&nbsp;원
                    </td>
                    <td>
                      <input type='text' size='3' name='rest_day' class='num' value='<%=ht.get("REST_DAY")%>'></td>
                    <td> 
                      <input type='text' size='10' name='rest_amt' class='num' value='<%=Util.parseDecimal(String.valueOf(ht.get("REST_AMT")))%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                    <td> 
        	    <%if(!cmd.equals("view") && ( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("보험업무",ck_acar_id) )){
        	    
        	        		String update_yn2 = "Y";
        	        		
        	        		/*매월 25일 기준에서 말일로 변경 요청(20190527)  */
        	        		String cost_ym = c_db.addMonth(String.valueOf(ht.get("COST_YM"))+"01", AddUtil.parseInt(var2)).substring(0,8);
        	        		String yyyymm = cost_ym.replaceAll("-", "");
        	        		int monthLastDay = AddUtil.getMonthDate(AddUtil.parseInt(yyyymm.substring(0,4)),AddUtil.parseInt(yyyymm.substring(4,6)));
        	        		String modify_deadline3 = cost_ym + String.valueOf(monthLastDay);
        	        		
							if(AddUtil.parseInt(AddUtil.replace(modify_deadline3,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
								update_yn2 = "N";
							}     
							
							out.println(modify_deadline3);
        	    %>	
					<%=Util.parseDecimal(cng_amt)%>원
					  &nbsp;&nbsp;
                       <%if((String.valueOf(ht.get("COST_YM")).equals("201702") || !update_yn2.equals("N")) && auth_rw.equals("6")){%> 
                      <a href='javascript:save("u", "<%=i%>")'><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      &nbsp;<a href='javascript:save("d", "<%=i%>")'><img src=../images/center/button_in_delete.gif align=absmiddle border=0></a>
                      
					  &nbsp;<a href='javascript:save("d_next", "<%=i%>")'><img src=../images/center/button_in_delete.gif align=absmiddle border=0>(올)</a>					  
                      
                       <%}%> 
                <%}%>			  		
                    </td>
                </tr>
          <%	total_amt = total_amt + Util.parseInt(String.valueOf(ht.get("COST_AMT")));
				total_amt3 = total_amt3 + cng_amt;
			  }%>
			  <%		chk_amt1 = total_amt;
			  		chk_amt2 = total_amt3;
			  %>
                <tr> 
                    <td class=title></td>
                    <td class=title>계</td>
                    <td class=title></td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt)%>&nbsp;원&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>			
                    <td class=title>&nbsp;</td>
                    <td class=title></td>
                    <td class=title style='text-align:left'>&nbsp;<%if(!cmd.equals("view") && ( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("보험업무",ck_acar_id) )){%><%=Util.parseDecimal(total_amt3)%><%}%></td>
                </tr>		  		  
            </table>
        </td>
    </tr>
		
	<%if(mode.equals("cls")){%>
    <tr> 
        <td width="510"></td>
        <td align="right" width="200"><a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
	<%}%>		
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험스케줄</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width="100%">
                <tr> 
                    <td class=title width=5%>회차</td>
                    <td class=title width=20%>구분</td>
                    <td class=title width=15%>납부예정일</td>
                    <td class=title width=15%>실납부예정일</td>			
                    <td class=title width=15%>납부금액</td>
                    <td class=title width=15%>납부일</td>
                    <td class=title width=15%>처리</td>
                </tr>
          <%	for(int i = 0 ; i < ins_scd_size ; i++){
					InsurScdBean scd = (InsurScdBean)ins_scd.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%> 
                    </td>
                    <td>
                      <select name='v_ins_tm2'>
                        <option value='0' <%if(scd.getIns_tm2().equals("0")){%>selected<%}%>>당초납입보험료</option>
                        <option value='1' <%if(scd.getIns_tm2().equals("1")){%>selected<%}%>>추가보험료</option>
                        <option value='2' <%if(scd.getIns_tm2().equals("2")){%>selected<%}%>>해지보험료</option>
                      </select>
                      </td>
                    <td>
                      <%=scd.getIns_est_dt()%>
                    </td>
                    <td>
                      <%=scd.getR_ins_est_dt()%>
                    </td>
                    <td>&nbsp; 
                      <%=Util.parseDecimal(scd.getPay_amt())%>원</td>
                    <td>&nbsp; 
                      <%=scd.getPay_dt()%>
                    </td>
                    <td> 
                    </td>
                </tr>
          <%	if(scd.getIns_tm2().equals("2")){
		  			total_amt2 = total_amt2 - scd.getPay_amt();
				}else{
		  			total_amt2 = total_amt2 + scd.getPay_amt();
				}
			  }%>
			  <%		chk_amt3 = total_amt2;			  		
			  %>			  
                <tr> 
                    <td class=title></td>
                    <td class=title>계</td>
                    <td class=title></td>
                    <td class=title></td>			
                    <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt2)%>&nbsp;&nbsp;원&nbsp;</td>
                    <td class=title></td>
                    <td class=title></td>
                </tr>		  		  		  
            </table>
        </td>
    </tr>	
	<%if(!cmd.equals("view") && ( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("보험업무",ck_acar_id) )){
		if(cha_amt.equals("") && total_amt-total_amt2 >0){
			cha_amt = String.valueOf(total_amt-total_amt2);
		}
		
		
	%>
	<tr> 
        <td colspan="2">
        	<%if(cost_size==0){
        		
        	%>
            <a href='javascript:save("reg_costs", "")' title='기간비용 삭제후 재등록'><img src=../images/center/button_reg_ggby.gif align=absmiddle border=0></a> 
          		<%-- <%}%> --%>
          <%}%>
		      <%if(!update_yn.equals("N") && cls.getCls_st().equals("1") && total_amt-total_amt2 >0 ){%>
		      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      <a href='javascript:save("cls_ins_costs", "")' title='해지로 인한 기간비용 정리하기'>[해지로 인한 기간비용 정리하기]</a>
		      <%}%>
		      <%if(!cls.getCls_st().equals("")){%>
		      &nbsp;&nbsp;&nbsp;( <%=cls.getCls_st()%> <%=cha_amt%> 해지사유발생일 : <%=AddUtil.ChangeDate2(cls.getExp_dt())%>, 청구일자 : <%=AddUtil.ChangeDate2(cls.getReq_dt())%> )
		      <%}%>
		</td>
    </tr>	
    <tr>
        <td align=center>
            <font color=red><%=chk_amt1-chk_amt2%> <%=chk_amt2-chk_amt3%> <%=chk_amt1-chk_amt3%></font>
        </td>
    </tr>
	<%}%>
  </form>
</table>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	<%if(!cha_amt.equals("")){%>
	if(fm.cha_amt.value == '' && <%=cha_amt%> >0){
		fm.cha_amt.value = <%=cha_amt%>;
	} 
	<%}%>
		
	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>

