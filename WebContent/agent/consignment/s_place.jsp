<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="cons_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 

<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String value 		= request.getParameter("value")==null?"":request.getParameter("value");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	String req_id 		= request.getParameter("req_id")==null?ck_acar_id:request.getParameter("req_id");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(req_id);
	
	//신차출발 추가(담당자 및 연락처 가져오기)
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
	UsersBean udt_mng_bean_b2 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산주차장관리"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산지점장"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전지점장"));			
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("대구지점장"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("광주지점장"));
	
	Vector vt = new Vector();
	if(value.equals("1")){//당사
		String[] capital_list = new String[] {"S1", "S2", "I1", "K3",  "S3", "S4", "S5", "S6"};
		boolean isCapital = Arrays.asList(capital_list).contains(br_id);
		
		vt = cons_db.getPlaceSearch1("", s_kd, t_wd, isCapital);
	}
	if(value.equals("2") && !t_wd.equals("")){//고객
		vt = cons_db.getPlaceSearch2Agent("", s_kd, t_wd, ck_acar_id);
	}
	if(value.equals("3") && !t_wd.equals("")){//협력업체
		vt = cons_db.getPlaceSearch3("", s_kd, t_wd);
	}
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function Disp1(gubun, nm, addr, mng_off, tel){
		var fm = document.form1;
		opener.form1.<%=st%>_place[<%=idx%>].value 	= nm;
		opener.form1.<%=st%>_comp[<%=idx%>].value 	= '(주)아마존카 '+mng_off;
		opener.form1.<%=st%>_tel[<%=idx%>].value 	= tel;
		<%//if(st.equals("from")){%>
		opener.form1.<%=st%>_title[<%=idx%>].value 	= '<%=user_bean.getUser_pos()%>';
		opener.form1.<%=st%>_man[<%=idx%>].value 	= '<%=user_bean.getUser_nm()%>';
		opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= '<%=user_bean.getUser_m_tel()%>';		
		<%//}%>
		self.close();
	}

	//계약선택
	function Disp2(client_id, firm_nm, client_nm, gubun, tel, m_tel, addr, title){
		var fm = document.form1;
		
		<%if(go_url.equals("/agent/car_pur/pur_doc_i.jsp")){%>
			opener.form1.rent_ext.value					= addr.substr(0,11);
		<%}else{%>
			opener.form1.<%=st%>_place[<%=idx%>].value 	= addr;
			opener.form1.<%=st%>_comp[<%=idx%>].value 	= firm_nm;
			opener.form1.<%=st%>_tel[<%=idx%>].value 	= tel;
			opener.form1.client_id[<%=idx%>].value 		= client_id;	
			opener.form1.<%=st%>_title[<%=idx%>].value 	= title;
			opener.form1.<%=st%>_man[<%=idx%>].value 	= client_nm;
			opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= m_tel;		
		<%}%>
			
		self.close();
	}		

	function Disp3(off_nm, own_nm, off_tel, off_addr){
		var fm = document.form1;
		opener.form1.<%=st%>_place[<%=idx%>].value 	= off_addr;
		opener.form1.<%=st%>_comp[<%=idx%>].value 	= off_nm;
		opener.form1.<%=st%>_tel[<%=idx%>].value 	= off_tel;
		opener.form1.<%=st%>_man[<%=idx%>].value 	= own_nm;		
		self.close();
	}
	
	// 신차출발 추가 
	function Disp4(dp4_n){
		var from_place = $("#d_n"+dp4_n).text();
		var from_comp = $("#d_a"+dp4_n).text();
		var from_title = $("#d_u"+dp4_n).val();
		var from_tel = $("#d_p"+dp4_n).val();
		var fm = document.form1;
		opener.form1.<%=st%>_place[<%=idx%>].value 	= from_place;
		opener.form1.<%=st%>_comp[<%=idx%>].value 	= from_comp;
		opener.form1.<%=st%>_title[<%=idx%>].value 	= from_title;	
		opener.form1.<%=st%>_tel[<%=idx%>].value 	= from_tel;
		opener.form1.<%=st%>_man[<%=idx%>].value 	= "";	
		opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= "";
		self.close();
	}
	
//-->
</script>
</head>

<body <%if(!value.equals("1")){%>onload="document.form1.t_wd.focus()"<%}%>>
<form name='form1' method='post' action='s_place.jsp'>
  <input type='hidden' name='st' value='<%=st%>'>    
  <input type='hidden' name='value' value='<%=value%>'>      
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <%if(value.equals("1")){%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>아마존카</span></span></td>
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
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">연번</td>
                    <td class=title width="15%">구분</td>
                    <td class=title width="30%">이름</td>			
                    <td class=title width="45%">주소</td>						
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                  <td><%=i+1%></td>
                  <td><%=ht.get("GUBUN")%></td>
                  <td><a href="javascript:Disp1('<%=ht.get("GUBUN")%>', '<%=ht.get("NM")%>', '<%=ht.get("ADDR")%>', '<%=ht.get("MNG_OFF")%>', '<%=ht.get("TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
                  <td><span title='<%=ht.get("ADDR")%>'><%=Util.subData(String.valueOf(ht.get("ADDR")), 18)%></span></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<%if(value.equals("3")){%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>협력업체</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>		
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>사업자번호</option>
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
    		
    		  <a href="javascript:search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>	
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
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td class=title width="5%">연번</td>
                  <td class=title width="12%">사업자번호</td>
                  <td class=title width="33%">상호</td>
                  <td class=title width="10%">대표자</td>
                  <td class=title width="15%">연락처</td>
                  <td class=title width="25%">주소</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                  <td><%=i+1%></td>
                  <td><%=ht.get("ENT_NO")%></td>		  
                  <td><a href="javascript:Disp3('<%=ht.get("OFF_NM")%>', '<%=ht.get("OWN_NM")%>', '<%=ht.get("OFF_TEL")%>', '<%=ht.get("OFF_ADDR")%>')" onMouseOver="window.status=''; return true"><%=ht.get("OFF_NM")%></a></td>
                  <td><%=ht.get("OWN_NM")%></td>
                  <td><%=ht.get("OFF_TEL")%></td>
                  <td><span title='<%=ht.get("OFF_ADDR")%>'><%=Util.subData(String.valueOf(ht.get("OFF_ADDR")), 12)%></span></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<%if(value.equals("2")){%>	
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>		  
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active' >
    		<a href="javascript:window.search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>		
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
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td class=title width="5%">연번</td>
                  <td class=title width="20%">상호</td>
                  <td class=title width="13%">구분</td>
                  <td class=title width="17%">연락처</td>
                  <td class=title width="45%">주소</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                  <td><%=i+1%></td>
                  <td>
                  	<% 
                  		// 고객 담당자 조건 수정 2021.01.20.
                  		String nm = "";
                  		String tel = "";
                  		String m_tel = "";
                  		String title = "";
                  		
                  		String mgr_nm1 = String.valueOf(ht.get("MGR_NM1"));
                  		String mgr_nm2 = String.valueOf(ht.get("MGR_NM2"));
                  		
                  		if(!mgr_nm1.equals("")){		// 차량이용자 정보 있을 경우 차량이용자가 담당자.
                  			nm = mgr_nm1;
                  			tel = String.valueOf(ht.get("MGR_TEL1"));
                  			m_tel = String.valueOf(ht.get("MGR_M_TEL1"));
                  			title = String.valueOf(ht.get("MGR_TITLE1"));
                  		} else if(!mgr_nm2.equals("")){	// 차량관계자 정보 있을 경우 차량관계자가 담당자.
                  			nm = mgr_nm2;
                  			tel = String.valueOf(ht.get("MGR_TEL2"));
                  			m_tel = String.valueOf(ht.get("MGR_M_TEL2"));
                  			title = String.valueOf(ht.get("MGR_TITLE2"));
                  		} // 차량이용자, 차량관계자 정보 모두 없을 경우 담당자 지정하지 않음.
                  	%>
                  	<%-- <a href="javascript:Disp2('<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CLIENT_NM")%>', '<%=ht.get("GUBUN")%>', '<%=ht.get("TEL")%>', '<%=ht.get("M_TEL")%>', '<%=ht.get("ADDR")%>', '<%=ht.get("TITLE")%>')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a> --%>
                  	<a href="javascript:Disp2('<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=nm%>', '<%=ht.get("GUBUN")%>', '<%=tel%>', '<%=m_tel%>', '<%=ht.get("ADDR")%>', '<%=title%>')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a>
                  </td>
                  <td><%=ht.get("GUBUN")%></td>
                  <td><%=ht.get("TEL")%></td>
                  <td><%=ht.get("ADDR")%></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	
	<!-- 신차출발 추가 -->
	<%if(value.equals("4")){%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>신차출발</span></span></td>
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
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">연번</td>
                    <td class=title width="15%">인수지</td>
                    <td class=title width="30%">지점/상호</td>			
                    <td class=title width="45%">주소</td>						
                </tr>
                <tr align="center">
                  <td>1</td>
                  <td>서울본사</td>
                  <td id="d_n1"><a href="javascript:Disp4(1);" onMouseOver="window.status=''; return true">영등포 영남주차장</a></td>
                  <td id="d_a1"><span>서울시 영등포구 영등포로 34길 9</span></td>
                  <td>
                  	<input type="hidden" id="d_u1" value="<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>">
                  	<input type="hidden" id="d_p1" value="<%=udt_mng_bean_s.getHot_tel()%>">
                  </td>
                </tr>
                <%-- <tr align="center">
                  <td>2</td>
                  <td>부산지점</td>                  
                  <td id="d_n2"><a href="javascript:Disp4(2);" onMouseOver="window.status=''; return true">조양골프연습장 주차장</a></td>
                  <td id="d_a2"><span>부산광역시 연제구 연산4동 585-1</span></td>
                  <td>
                  	<input type="hidden" id="d_u2" value="<%=udt_mng_bean_b2.getDept_nm()%> <%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>">
                  	<input type="hidden" id="d_p2" value="<%=udt_mng_bean_b2.getHot_tel()%>">
                  </td>
                </tr> --%>
                <tr align="center">
                  <td>2</td>
                  <td>부산지점</td>                  
                  <td id="d_n3"><a href="javascript:Disp4(3);" onMouseOver="window.status=''; return true">웰메이드오피스텔 지하1층 주차장</a></td>
                  <td id="d_a3"><span>부산광역시 연제구 거제천로 230번길 70 지하1층 (연산동,웰메이드오피스텔)웰메이드주차장</span></td>
                  <td>
                  	<input type="hidden" id="d_u3" value="<%=udt_mng_bean_b2.getDept_nm()%> <%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>">
                  	<input type="hidden" id="d_p3" value="<%=udt_mng_bean_b2.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>3</td>
                  <td>부산지점</td>                  
                  <td id="d_n4"><a href="javascript:Disp4(4);" onMouseOver="window.status=''; return true">유림카(썬팅집)</a></td>
                  <td id="d_a4"><span>부산광역시 연제구 연산4동 700-5</span></td>
                  <td>
                  	<input type="hidden" id="d_u4" value="<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>">
                  	<input type="hidden" id="d_p4" value="<%=udt_mng_bean_b.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>4</td>
                  <td>대전지점</td>                  
                  <td id="d_n5"><a href="javascript:Disp4(5);" onMouseOver="window.status=''; return true">미성테크</a></td>
                  <td id="d_a5"><span>대전광역시 유성구 온천북로59번길 10(봉명동 690-3)</span></td>
                  <td>
                  	<input type="hidden" id="d_u5" value="<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>">
                  	<input type="hidden" id="d_p5" value="<%=udt_mng_bean_d.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>5</td>
                  <td>대구지점</td>                  
                  <td id="d_n6"><a href="javascript:Disp4(6);" onMouseOver="window.status=''; return true">대구 썬팅집</a></td>
                  <td id="d_a6"><span>대구광역시 달서구 신당동 321-86</span></td>
                  <td>
                  	<input type="hidden" id="d_u6" value="<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>">
                  	<input type="hidden" id="d_p6" value="<%=udt_mng_bean_g.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>6</td>
                  <td>광주지점</td>                  
                  <td id="d_n7"><a href="javascript:Disp4(7);" onMouseOver="window.status=''; return true">용용이자동차용품점</a></td>
                  <td id="d_a7"><span>광주광역시 광산구 상무대로 233 (송정동 1360)</span></td>
                  <td>
                  	<input type="hidden" id="d_u7" value="<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>">
                  	<input type="hidden" id="d_p7" value="<%=udt_mng_bean_j.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>7</td>
                  <td>부산지점</td>                  
                  <td id="d_n8"><a href="javascript:Disp4(8);" onMouseOver="window.status=''; return true">스마일TS</a></td>
                  <td id="d_a8"><span>부산시 연제구 안연로7번나길 10(연산동 363-13번지)</span></td>
                  <td>
                  	<input type="hidden" id="d_u8" value="<%=udt_mng_bean_b2.getDept_nm()%> <%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>">
                  	<input type="hidden" id="d_p8" value="<%=udt_mng_bean_b2.getHot_tel()%>">
                  </td>
                </tr>
            </table>
	    </td>
    </tr>	
	<%}%>
	
    <tr> 
        <td align="center">
	    <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	    </td>
    </tr>
</table>
</form>
</body>
</html>