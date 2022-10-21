<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.cont.*,acar.client.*, acar.user_mng.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 			= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 				= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 			= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String o_rent_mng_id= request.getParameter("o_rent_mng_id")==null?"":request.getParameter("o_rent_mng_id");
	String o_rent_l_cd 	= request.getParameter("o_rent_l_cd")==null?"":request.getParameter("o_rent_l_cd");	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String seq 					= request.getParameter("seq")==null?"":request.getParameter("seq");
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//배정관리
	CarPurDocListBean cpd_bean = cod.getCarPurCom(o_rent_mng_id, o_rent_l_cd, com_con_no);
	
	//출고영업소정보
	CarOffBean co_bean = cod.getCarOffBean(cpd_bean.getCar_off_id());
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	UsersBean dlv_mng_bean 	= umd.getUsersBean(cpd_bean.getDlv_mng_id());
		
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
	UsersBean udt_mng_bean_b2 = umd.getUsersBean(nm_db.getWorkAuthUser("부산주차장관리"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산지점장"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전지점장"));			
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("대구지점장"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("광주지점장"));

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">
<!--
	//계약 연동	
	function search_cont(){
		var fm = document.form1;
		fm.action = "search_cont.jsp";
		window.open("about:blank", "S_CONT", "left=350, top=50, width=1050, height=700, scrollbars=yes, status=yes");
		fm.target = "S_CONT";
		fm.submit();
	}

	//인수지로 배달지 디폴트
	function setOff(){
		var fm = document.form1;
		
		var deposit_len = fm.udt_firm.length;			
		for(var i = 1 ; i < deposit_len ; i++){
			fm.udt_firm.options[i] = null;			
		}
		
		if(fm.udt_st.value == '1'){
			fm.udt_firm.options[1] = new Option('영등포 영남주차장', '영등포 영남주차장');					
			fm.udt_firm.value = '영등포 영남주차장';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '2'){
			<%if(AddUtil.getDate2(4) >= 20210205){%>
			fm.udt_firm.options[1] = new Option('스마일TS', '스마일TS');
			fm.udt_firm.options[2] = new Option('웰메이드오피스텔 지하1층 주차장', '웰메이드오피스텔 지하1층 주차장');
			fm.udt_firm.options[3] = new Option('유림카(썬팅집)', '유림카(썬팅집)');
			fm.udt_firm.value = '스마일TS';
			<%}else{%>
			fm.udt_firm.options[1] = new Option('조양골프연습장 주차장', '조양골프연습장 주차장');
			fm.udt_firm.options[2] = new Option('웰메이드오피스텔 지하1층 주차장', '웰메이드오피스텔 지하1층 주차장');
			fm.udt_firm.options[3] = new Option('유림카(썬팅집)', '유림카(썬팅집)');
			fm.udt_firm.options[4] = new Option('스마일TS', '스마일TS');
			fm.udt_firm.value = '조양골프연습장 주차장';
			<%}%>
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '3'){
			fm.udt_firm.options[1] = new Option('미성테크', '미성테크');								
			fm.udt_firm.value = '미성테크';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '5'){
			fm.udt_firm.options[1] = new Option('대구 썬팅집', '대구 썬팅집');											
			fm.udt_firm.value = '대구 썬팅집';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '6'){
			fm.udt_firm.options[1] = new Option('용용이자동차용품점', '용용이자동차용품점');											
			fm.udt_firm.value = '용용이자동차용품점';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '4'){
			fm.udt_firm.options[1] = new Option('<%=client.getFirm_nm()%>', '<%=client.getFirm_nm()%>');											
			fm.udt_firm.value = '<%=client.getFirm_nm()%>';
			cng_input1(fm.udt_firm.value);
		}			
	}	
		
	//차량인수지 선택시 용품업체 셋팅
	function cng_input1(value){
		var fm = document.form1;
		
		if(fm.udt_firm.value == '영등포 영남주차장'){					
			fm.udt_addr.value 	= '서울시 영등포구 영등포로 34길 9';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_s.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_s.getUser_id()%>';			
		}else if(fm.udt_firm.value == '유림카(썬팅집)'){				
			fm.udt_addr.value 	= '부산광역시 연제구 연산4동 700-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b.getUser_id()%>';			
		}else if(fm.udt_firm.value == '조양골프연습장 주차장'){					
			fm.udt_addr.value 	= '부산광역시 연제구 연산4동 585-1';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '스마일TS'){			
			fm.udt_addr.value 	= '부산시 연제구 안연로7번나길 10(연산동 363-13번지)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';	
		}else if(fm.udt_firm.value == '웰메이드오피스텔 지하1층 주차장'){					
			fm.udt_addr.value 	= '부산광역시 연제구 거제천로 230번길 70 지하1층 (연산동,웰메이드오피스텔)웰메이드주차장';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '오토카용품'){			
			fm.udt_addr.value 	= '대전광역시 유성구 노은동 527-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';						
		}else if(fm.udt_firm.value == '미성테크'){				
			fm.udt_addr.value = '대전광역시 유성구 온천북로59번길 10(봉명동 690-3)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';			
		}else if(fm.udt_firm.value == '대구 썬팅집'){				
			fm.udt_addr.value 	= '대구광역시 달서구 신당동 321-86';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_g.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_g.getUser_id()%>';			
		}else if(fm.udt_firm.value == '용용이자동차용품점'){				
			fm.udt_addr.value 	= '광주광역시 광산구 상무대로 233 (송정동 1360)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_j.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_j.getUser_id()%>';			
		}else if(fm.udt_firm.value == '<%=client.getFirm_nm()%>'){				
			fm.udt_addr.value 	= '<%=client.getO_addr()%>';
			fm.udt_mng_nm.value 	= '<%=client.getCon_agnt_dept()%> <%=client.getCon_agnt_nm()%> <%=client.getCon_agnt_title()%>';
			fm.udt_mng_tel.value 	= '<%=client.getO_tel()%>';
			fm.udt_mng_id.value     = '';		
		}
					
	}

	function Save(){
		fm = document.form1;
	
		if(fm.rent_l_cd.value=='') { alert('계약을 조회하십시오.'); return; }
		
		if(!confirm("등록 하시겠습니까?"))	return;
		fm.action = "rePurcomReg_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	function p_reload(){
		fm = document.form1;
		fm.action = "rePurcomReg.jsp";
		fm.target = "_self";
		fm.submit();
	}	


//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="o_rent_mng_id" value="<%=o_rent_mng_id%>">
<input type="hidden" name="o_rent_l_cd" value="<%=o_rent_l_cd%>">
<input type="hidden" name="com_con_no" value="<%=com_con_no%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>"/>
<input type="hidden" name="car_off_nm" value="<%=co_bean.getCar_off_nm()%>">
<input type="hidden" name="car_nm" value="<%=AddUtil.replace(cpd_bean.getCar_nm(),"&nbsp;","")%>"/>
<input type="hidden" name="opt" value="<%=cpd_bean.getOpt()%>">
<input type="hidden" name="colo" value="<%=cpd_bean.getColo()%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량예약 입력사항</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
                    <td width=13% class=title>출고영업소</td>
                    <td width=17%>&nbsp;<%=co_bean.getCar_off_nm()%></td>
                    <td width=10% class=title>계출번호</td>
                    <td width=20%>&nbsp;<%=com_con_no%></td>
                    <td width=10% class=title>차명</td>
                    <td width=30%>&nbsp;<%=cpd_bean.getCar_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>     
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약연동</span></td>
    </tr> 
    <tr>
        <td class=line2></td>
    </tr>       
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                     
                    <td width=14% class=title>계약번호</td>
                    <td>&nbsp;<input type='text' size='15' name='rent_l_cd' maxlength='20' class='default' value='<%=rent_l_cd%>' readonly>
                    	<a href='javascript:search_cont()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>	
                    </td>
 		</tr>    		    
            </table>
        </td>
    </tr>  
    <!--
    <%if(!rent_l_cd.equals("")){%>    
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
                    <td width=7% rowspan="3" class=title>배정</td>
                    <td width=7% class=title>구분</td>
                    <td width=10%>&nbsp;
                        <%if(cpd_bean.getDlv_st().equals("2")){%>
                        [배정]&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%>
        		            <%}else{%>
                        [예정]&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%>
        		            <%}%>
        	          </td>
                    <td width=7% rowspan="3" class=title>배달지</td>
                    <td width=7% class=title>구분</td>
                    <td width="28%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(cpd_bean.getUdt_st().equals("1"))%> selected<%%>>서울본사</option>
        				<option value="2" <%if(cpd_bean.getUdt_st().equals("2"))%> selected<%%>>부산지점</option>
        				<option value="3" <%if(cpd_bean.getUdt_st().equals("3"))%> selected<%%>>대전지점</option>
        				<option value="5" <%if(cpd_bean.getUdt_st().equals("5"))%> selected<%%>>대구지점</option>
        				<option value="6" <%if(cpd_bean.getUdt_st().equals("6"))%> selected<%%>>광주지점</option>
        				<option value="4" <%if(cpd_bean.getUdt_st().equals("4"))%> selected<%%>>고객</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>담당자</td>
                    <td width="7%" class=title>부서/성명</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cpd_bean.getUdt_mng_nm()%>' class='whitetext' ></td>
    		    </tr>    		   
                <tr>
                  <td class=title>출고사무소</td>
                  <td>&nbsp;<%=cpd_bean.getDlv_ext()%></td>
                  <td class=title>지점/상호</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==선택==</option>
        		    <%if(cpd_bean.getUdt_st().equals("1")){%>
        		    <option value="영등포 영남주차장" <%if(cpd_bean.getUdt_firm().equals("영등포 영남주차장"))%> selected<%%>>영등포 영남주차장</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("2")){%>
        		    <option value="조양골프연습장 주차장" <%if(cpd_bean.getUdt_firm().equals("조양골프연습장 주차장"))%> selected<%%>>조양골프연습장 주차장</option>
        		    <option value="웰메이드오피스텔 지하1층 주차장" <%if(cpd_bean.getUdt_firm().equals("웰메이드오피스텔 지하1층 주차장"))%> selected<%%>>웰메이드오피스텔 지하1층 주차장</option>
        		    <option value="유림카(썬팅집)" <%if(cpd_bean.getUdt_firm().equals("유림카(썬팅집)"))%> selected<%%>>유림카(썬팅집)</option>
        		    <option value="스마일TS" <%if(cpd_bean.getUdt_firm().equals("스마일TS"))%> selected<%%>>스마일TS</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("3")){%>
        		    <option value="미성테크" <%if(cpd_bean.getUdt_firm().equals("미성테크"))%> selected<%%>>미성테크</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("5")){%>
        		    <option value="대구 썬팅집" <%if(cpd_bean.getUdt_firm().equals("대구 썬팅집"))%> selected<%%>>대구 썬팅집</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("6")){%>
        		    <option value="용용이자동차용품점" <%if(cpd_bean.getUdt_firm().equals("용용이자동차용품점"))%> selected<%%>>용용이자동차용품점</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cpd_bean.getUdt_firm().equals(client.getFirm_nm()))%> selected<%%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
        		</td>
                  <td class=title>연락처</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cpd_bean.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
                <tr>
                  <td class=title>배달탁송료</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                  <td class=title>주소</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cpd_bean.getUdt_addr()%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr>    
    <tr>  
        <td align="right">        	
		        <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
		        &nbsp;&nbsp;
		        <a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>	
    </tr>                    
    <%}%>   
    -->
    <tr>  
        <td align="right">        	
		        <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
		        &nbsp;&nbsp;
		        <a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>	
    </tr>                    
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr>
        <td>※ 연동을 하면 기존 계출정보를 그대로 넘깁니다. 연동후 차가, D/C, 배정정보 등이 연동하는 계약에 맞는지 확인하십시오.</td>
    </tr>	
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
