<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, acar.cont.*, acar.user_mng.*,  acar.estimate_mng.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"6":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CarServDatabase csd = CarServDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	//정비/점검(면책금)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);
	
	//상대차량 인적사항
	OtAccidBean oa_r [] = as_db.getOtAccid(c_id, accid_id);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
	var popObj = null;
<!--

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0		
		popObj = window.open(theURL,winName,features);		
	}		

	//수정하기
	function save(cmd, idx){
		var fm = document.form1;
		fm.idx2.value = idx;
		fm.cmd.value = cmd;
		if(fm.accid_id.value == ''){ alert("상단을 먼저 등록하십시오."); return; }		
		if(cmd == 'u'){
			if(!confirm('수정하시겠습니까?')){	return;	}
		}else{
			if(!confirm('등록하시겠습니까?')){	return;	}		
		}
		fm.target = "i_no";
		fm.submit();
	}
				
	function ServDelete(serv_id){
		var fm = document.form1;	
		fm.serv_id.value = serv_id;
		fm.wk_st.value = 'servdel';
		if(fm.accid_id.value == ''){ alert("상단을 먼저 등록하십시오."); return; }
		if(!confirm('삭제하시겠습니까?')){
			return;
		}		
		fm.action = "accid_gu_a.jsp"
		fm.target = "i_no"
		fm.submit();

	}	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='cmd' value='<%=cmd%>'>
<input type='hidden' name='size' value='<%=oa_r.length%>'>
<input type='hidden' name='idx2' value=''>	  		
<input type='hidden' name='go_url' value='<%=go_url%>'>  	
<input type='hidden' name="wk_st" value=''>
<input type='hidden' name="serv_id" value=''>		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>물적사고</span></td>
        <td align="right">&nbsp;&nbsp; </td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>1. 당사차량</font></td>
        <td align="right">
	    <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	 
	    
	    <% if (!a_bean.getSettle_st().equals("1")) {%> <!-- 사고 종결이 아니면 -->
	    	<a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_reg.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&accid_st=<%=a_bean.getAccid_st()%>&cmd=4','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=700,top=50,left=50')"><img src="/acar/images/center/button_reg_jc.gif" align="absmiddle" border="0"></a> 
	    <%} %>
	    
	    <%	}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="3%">연번</td>
                    <td class=title width="7%">구분</td>
                    <td class=title width="5%">견적서</td>					
                    <td class=title width="7%">정비일자</td>
                    <td class=title width="18%">정비업체명</td>
                    <td class=title width="9%">연락처</td>
                    <td class=title width="9%">팩스번호</td>
                    <td class=title width="9%">지출금액</td>
                    <td class=title width="23%">정비내용</td>
                    <td class=title width="5%">수정</td>
                    <td class=title width="5%">삭제</td>			
                </tr>
                <%for(int i=0; i<s_r.length; i++){
        		s_bean = s_r[i];
					
			ServItem2Bean si_r [] = csd.getServItem2All(s_bean.getCar_mng_id(), s_bean.getServ_id());
			String f_item = "";
			String a_item = "";
			for(int j=0; j<si_r.length; j++){
				si_bean = si_r[j];
				if(j==0) f_item = si_bean.getItem();
				if(j==si_r.length-1){
       				    	a_item += si_bean.getItem();
       				}else{
       				    	a_item += si_bean.getItem()+",";
       				}
       			}					
			
			//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
			String content_code = "SERVICE";
			String content_seq  = s_bean.getCar_mng_id()+""+s_bean.getServ_id();

			Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			int attach_vt_size = attach_vt.size();				
		%>
                <tr id='tr_one_accid' style="display:''"> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%if(s_bean.getServ_st().equals("7")){%>재리스정비
                    	<%}else if(s_bean.getServ_st().equals("4")){%>운행자차
                    	<%}else if(s_bean.getServ_st().equals("5")){%>사고자차                    	
                    	<%}else if(s_bean.getServ_st().equals("12")){%>해지정비
                    	<%}else if(s_bean.getServ_st().equals("13")){%>자차
                    	<%}else{%>&nbsp;
                    	<%}%>  
                    </td>					
                    <td align="center">
			<%if(attach_vt_size > 0){%>
			    <%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    			    %>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
    				<% if ( !a_bean.getSettle_st().equals("1") )  {	 %>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    				<% } %>
    					<%if(j+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
        		<%}else{%>
        		    <a class=index1 href="javascript:MM_openBrWindow('upload.jsp?br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=s_bean.getServ_id()%>&mode=<%=mode%>&gubun=pdf','popwin','scrollbars=no,status=no,resizable=yes,width=500,height=200,left=250, top=250')", title="견적서를 업로드하시려면 클릭하세요"><img src="/acar/images/center/button_in_reg.gif" align="absmiddle" border="0"></a>
        		<%}%>        			
        	    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean.getServ_dt())%></td>
                    <td align="center"><%=s_bean.getOff_nm()%></td>
                    <td align="center"><%=s_bean.getOff_tel()%></td>
                    <td align="center"><%=s_bean.getOff_fax()%></td>
                    <td align="right"><%=AddUtil.parseDecimal(s_bean.getRep_amt())%>원 </td> 
                    <td align="center">
			<%if(!a_item.equals("")){%>
			<span title="<%=a_item%>">&nbsp;<%=f_item%><% if(si_r.length>1){ %>외 <font color="red"><%=si_r.length-1%></font>건 <% } %>										
			<%}else{%>
			<span title="<%=s_bean.getRep_cont()%>">&nbsp;<%=Util.subData(s_bean.getRep_cont(),10)%>		
			<%}%> 
		    </td>
                    <td align="center">               
                        <%if( !s_bean.getRep_cont().equals("면책금 선청구분") ) { %>
	        	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	        	<a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_reg.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=s_bean.getServ_id()%>&cmd=4','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=700,top=20,left=20')"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a>
	        	<%}%>
	        	<%}%>	
        	    </td>
                    <td align="center">
                        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                        
        			<%if(  ( s_bean.getReg_id().equals(user_id) && !s_bean.getSac_yn().equals("Y")  )      ||  (    nm_db.getWorkAuthUser("전산팀",user_id)  && !s_bean.getSac_yn().equals("Y")   )          ) {%>
        		          <% if ( !a_bean.getSettle_st().equals("1")) {%> <!-- 사고 종결이 아니면 -->
                        <a href="javascript:ServDelete('<%=s_bean.getServ_id()%>')"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
                        <% } %>
                       <%}%>
                  <%}%>			  
        	    </td>						
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
    <%if(s_r.length>0){%>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td colspan=2>* 견적서를 스캔 등록하거나 볼수 있습니다.</td>
    </tr>		
    <%	if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("3")){//피해,쌍방,상대과실-시세하락손해 대상여부
		int amor_req_tot_amt = 0;
		if(oa_r.length > 0){
			for(int i=0; i<oa_r.length; i++){
    				oa_bean = oa_r[i];
				amor_req_tot_amt += oa_bean.getAmor_req_amt();
			}
		}
		String dlv_mon = request.getParameter("dlv_mon")==null?"":request.getParameter("dlv_mon");
		String car_amt = request.getParameter("car_amt")==null?"":request.getParameter("car_amt");
		String tot_amt = request.getParameter("tot_amt")==null?"":request.getParameter("tot_amt");
		String req_est_amt = request.getParameter("req_est_amt")==null?"":request.getParameter("req_est_amt");
		if(amor_req_tot_amt==0 && req_est_amt.equals("")){
			Hashtable accid_1 = as_db.getAccidAmor(c_id, accid_id);
			dlv_mon 	= String.valueOf(accid_1.get("DLV_MON"));
			car_amt 	= String.valueOf(accid_1.get("CAR_AMT"));
			tot_amt 	= String.valueOf(accid_1.get("TOT_AMT"));
			req_est_amt = String.valueOf(accid_1.get("REQ_EST_AMT"));
		}
		if(amor_req_tot_amt==0 && !req_est_amt.equals("0") && !req_est_amt.equals("")){%>
    <tr>
        <td colspan=2>※ 출고경과 : <%=dlv_mon%>년이내 / 차량잔가 : <%=AddUtil.parseDecimal(car_amt)%>원 / 수리비용 : <%=AddUtil.parseDecimal(tot_amt)%>원 / 청구가능금액 : <%=AddUtil.parseDecimal(req_est_amt)%>원
	    <br>&nbsp;&nbsp;(시세하락손해를 청구할 수 있습니다. 시세하락손해 청구/입금은 보험처리결과에 입력하시기 바랍니다.)
	</td>
    </tr>		
    <%		}%>
    <%	}%>		
    <%}%>
    
    <%if(a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3")){%>
	<tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>2. 상대차량</font></td>
        <td align="right">
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="30">연번</td>
                    <td class=title width="40">구분</td>
                    <td class=title width="60">운전자</td>
                    <td class=title width="90">차량번호</td>
                    <td class=title width="80">정비일자</td>
                    <td class=title width="100">정비업체명</td>
                    <td class=title width="80">연락처</td>
                    <td class=title width="80">팩스번호</td>
                    <td class=title width="80">정비금액</td>
                    <td class=title width="120">정비내용</td>
                    <td class=title width="40">처리</td>
                </tr>
    		<%if(a_bean.getDam_type2().equals("Y")){%>
                <%	for(int i=0; i<oa_r.length; i++){
        			oa_bean = oa_r[i];
        	%>
                <tr id='tr_one_accid' style="display:''"> 
                    <td align="center"><%=i+1%></td>
                    <td align="center">대물<%=oa_bean.getSeq_no()%><input type='hidden' name='seq_no' value='<%=oa_bean.getSeq_no()%>'></td>
                    <td align="center"><%=oa_bean.getOt_driver()%></td>
                    <td align="center"><%=oa_bean.getOt_car_no()%></td>
                    <td align="center">
                      <input type="text" name="serv_dt" value="<%=AddUtil.ChangeDate2(oa_bean.getServ_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center">
                      <input type="text" name="off_nm" value="<%=oa_bean.getOff_nm()%>" size="13" class=text >
                    </td>
                    <td align="center">
                      <input type="text" name="off_tel" value="<%=oa_bean.getOff_tel()%>" size="10" class=text >
                    </td>
                    <td align="center">
                      <input type="text" name="off_fax" value="<%=oa_bean.getOff_fax()%>" size="10" class=text>
                    </td>
                    <td align="center">
                      <input type="text" name="serv_amt" value="<%=AddUtil.parseDecimal(oa_bean.getServ_amt())%>" size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_rep(this)'> 
                      원</td>
                    <td align="center">
                      <input type="text" name="serv_cont" value="<%=oa_bean.getServ_cont()%>" size="16" class=text>
                    </td>
                    <td align="center">
        		<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        		<a href="javascript:save('u', '<%=i%>')"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a>
        		<%	}%>
        	    </td>
                </tr>
                <%	}%>
    		<%}else{%>		  
                <tr> 
                    <td align="center" colspan="11">사고규모-대물이 체크되지 않았습니다.</td>
                </tr>		  
    		<%}%>		  		  
            </table>
        </td>
    </tr>
    <%}%>
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>