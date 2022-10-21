<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.cus_pre.*, acar.user_mng.*, acar.condition.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CusPre_Database cp_db = CusPre_Database.getInstance();
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	Hashtable id = c_db.getDamdang_id(user_nm);
	user_id = String.valueOf(id.get("USER_ID"));
	
	//신규계약개시
	Vector conts1 = cp_db.getContList(br_id, user_id, "1");
	
	//계약만료예정
	Vector conts2 = cp_db.getContList(br_id, user_id, "2");
	
	
	//로그인ID&영업소ID&권한
	String acar_id = ck_acar_id;
%>
<%	%>
<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	//영업담당자 변경
	function cng_bus(m_id, l_cd){
//		window.open("/acar/car_rent/cng_bus.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=cus", "CNG_BUS", "left=100, top=10, width=400, height=220, scrollbars=yes, status=yes");
		window.open("/fms2/lc_rent/cng_item.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&cng_item=bus_id2&from_page=/acar/cus_pre/cus_pre_sc_ct.jsp", "CNG_BUS", "left=100, top=10, width=720, height=450, scrollbars=yes, status=yes");
	}
	//새로고침
	function CusPreCtRelode(){
		var fm = document.form1;
		fm.action = 'cus_pre_sc_ct.jsp';		
		fm.submit();					
	}	
		//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	function view_memo(m_id, l_cd, c_id, tm_st, accid_id, serv_id, mng_id){
		
		window.open("/acar/condition/rent_memo_frame_s.jsp?tm_st="+tm_st+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&mng_id="+mng_id, "INS_MEMO", "left=100, top=100, width=700, height=600");
	}

	//장기계약 계약서 내용 보기
	function view_cont(m_id, l_cd){
		var fm = document.form1;
	//	fm.rent_mng_id.value = m_id;
	//	fm.rent_l_cd.value = l_cd;
		fm.target ='d_content';
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp?rent_mng_id='+m_id+'&rent_l_cd='+l_cd;
		fm.submit();
	}
	
	//장기계약 임의연장 등록
	function reg_im_cont(m_id, l_cd, car_no){
	//	var fm = document.form1;
	//	var fm2 = document.form2;
		
	//	if(confirm('임의연장 등록으로 넘어가겠습니까?')){	

		//	fm2.target ='c_head';
		//	fm2.action = '/fms2/lc_rent/lc_im_renew_h.jsp?s_kd=2&t_wd='+car_no;
		//	fm2.submit();		
		
		//	fm.target ='c_body';
		//	fm.action = '/fms2/lc_rent/lc_im_renew_c.jsp?rent_mng_id='+m_id+'&rent_l_cd='+l_cd;
		//	fm.submit();
		
		window.open("/fms2/lc_rent/lc_im_renew_c.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=pop", "RENEW", "left=10, top=10, width=1050, height=700, scrollbars=yes");
	//	}
	}
	
	
//-->
</script>
</head>

<body><a name="top"></a>
<form name='form2' method='post' action=''>
</form>
<form name='form1' method='post' action=''>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><a name='5'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신규계약개시 (D+30일) : 총 <font color="#FF0000"><%= conts1.size() %></font>건</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%" class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=3% class='title'>연번</td>
                    <td width=19% class='title'>상호</td>
                    <td width=11% class='title'>차량번호</td>
                    <td width=13% class='title'>차종</td>
                    <td width=11% class='title'>대여개시일</td>
                    <td width=11% class='title'>대여구분</td>
                    <td width=8% class='title'>대여개월</td>
                    <td width=8% class='title'>최초영업</td>
                    <td width=8% class='title'>영업담당</td>
                    <td width=8% class='title'>관리담당</td>
                </tr>
          <%if(conts1.size() > 0){
         		for(int i = 0 ; i < conts1.size() ; i++){
					RentListBean cont = (RentListBean)conts1.elementAt(i); %>
                <tr> 
                    <td align='center'>                   		
                    <%= i+1 %></td>
                    <td align='center'><a href="javascript:view_cont('<%=cont.getRent_mng_id()%>', '<%=cont.getRent_l_cd()%>')" onMouseOver="window.status=''; return true" title='<%=cont.getFirm_nm()%> 계약관리로 이동'>                   	
                    	<%=AddUtil.subData(cont.getFirm_nm(), 9)%>
                   	  </a></span></td>
                    <td align='center'><span title='<%=cont.getCar_no()%>'><%=cont.getCar_no()%></span></td>
                    <td align='center'><span title='<%=cont.getCar_nm()%>'><%=AddUtil.subData(cont.getCar_nm(), 10)%></span></td>
                    <td align='center'><%=cont.getRent_start_dt()%></td>
                    <td align='center'><% if(cont.getCar_st().equals("1")) out.print("렌트");
        			                      else if(cont.getCar_st().equals("3")) out.print("리스"); %> <%=cont.getRent_way()%></td>
                    <td align='center'><%if(!cont.getCon_mon().equals("")){%>
                      <%=cont.getCon_mon()%>개월
                      <%}else{%>
                      -
                      <%}%></td>
                    <td align='center'><%=c_db.getNameById(cont.getBus_id(), "USER")%></td>
                    <td align='center'><%=c_db.getNameById(cont.getBus_id2(), "USER")%></td>
                    <td align='center'><% if(cont.getMng_id().equals("")){%>미지정<%}else{%><%=c_db.getNameById(cont.getMng_id(), "USER")%><%}%></td>
                </tr>
          <% }
		  }else{ %>
                <tr> 
                    <td colspan="10" align='center'>해당하는 신규 계약건이 없습니다.</td>
                </tr>
          <%}%>
             </table>
        </td>
    </tr>
    <tr> 
        <td><a name='6'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약만료예정 (D-30일) : 총 <font color="#FF0000"><%= conts2.size() %></font>건</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                   <td width=3% class='title'>연번</td>
                    <td width=13% class='title'>상호</td>
                    <td width=10% class='title'>차량번호</td>
                    <td width=14% class='title'>차종</td>
                    <td width=7% class='title'>대여개시일</td>
                    <td width=7% class='title'>대여만료일</td>
                    <td width=8% class='title'>스케줄종료일</td>					
                    <td width=8% class='title'>대여구분</td>
                    <td width=6% class='title'>영업사원</td>
                    <td width=6% class='title'>최초영업</td>										
                    <td width=6% class='title'>영업담당</td>
                    <td width=6% class='title'>관리담당</td>
                    <td width=6% class='title'>진행</td>
                </tr>
          <%if(conts2.size() > 0){
         		for(int i = 0 ; i < conts2.size() ; i++){
					RentListBean cont = (RentListBean)conts2.elementAt(i);
					//임의연장
					Hashtable ht = cdb.getFeeImList2(cont.getRent_mng_id(), cont.getRent_l_cd(), "");
					%>
                <tr> 
                    <td align='center'>
                      <a href="javascript:view_memo('<%=cont.getRent_mng_id()%>','<%=cont.getRent_l_cd()%>','','1','','','')" onMouseOver="window.status=''; title='계약만료메모'; return true; " ) ><%= i+1%></a>
					</td>
					<!--<td align='center'><%=cont.getRent_l_cd()%></td>-->
                    <td align='center'> 
					  <a href="javascript:view_cont('<%=cont.getRent_mng_id()%>', '<%=cont.getRent_l_cd()%>')" onMouseOver="window.status=''; return true" title='<%=cont.getFirm_nm()%> 계약관리로 이동'>                   	
                    	<%=AddUtil.subData(cont.getFirm_nm(), 9)%>
                   	  </a>
                    </td>
                    <td align='center'><span title='<%=cont.getCar_no()%>'><%=cont.getCar_no()%></span></td>
                    <td align='center'><span title='<%=cont.getCar_nm()%>'>
                   <% if  (  cont.getScan_file().equals("8") ) { %><font color=red>[전]</font><% } %>&nbsp; <%=AddUtil.subData(cont.getCar_nm(), 10)%></span></td>		
                 
                    <td align='center'><%=cont.getRent_start_dt()%></td>
                    <td align='center'><%=cont.getRent_end_dt()%></td>
					<td align='center'><a href="javascript:reg_im_cont('<%=cont.getRent_mng_id()%>', '<%=cont.getRent_l_cd()%>', '<%=cont.getCar_no()%>')" onMouseOver="window.status=''; return true" title='<%=cont.getFirm_nm()%> 임의연장등록으로 이동'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></a></td>
                    <td align='center'><% if(cont.getCar_st().equals("1")) out.print("렌트");
        			                      else if(cont.getCar_st().equals("3")) out.print("리스"); %> <%=cont.getRent_way()%></td>
                    <td align='center'><%=cont.getEmp_nm()%></td>							
                    <td align='center'><%=c_db.getNameById(cont.getBus_id(), "USER")%></td>								  
                    <td align='center'><%=c_db.getNameById(cont.getBus_id2(), "USER")%></td>
                    <td align='center'><%=c_db.getNameById(cont.getMng_id(), "USER")%></td>
                     <td align='center'>
					 <a href="javascript:view_memo('<%=cont.getRent_mng_id()%>','<%=cont.getRent_l_cd()%>','','1','','','')" onMouseOver="window.status=''; title='계약만료메모'; return true; " ) >
					 <% if(cont.getRe_bus_nm().equals("")){%>
					 <img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0>
					 <%}else{%>
					 <%=cont.getRe_bus_nm()%>
					 <%}%>
					 </a>
					 </td>
                </tr>
          <% }
		  }else{ %>
                <tr> 
                    <td colspan="13" align='center'>해당하는 만료 계약건이 없습니다.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>	    
	
</table>
</form>
</body>
</html>

