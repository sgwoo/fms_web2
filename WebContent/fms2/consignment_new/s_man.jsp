<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.consignment.*, acar.cont.*"%>
<jsp:useBean id="cons_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%//@ include file="/acar/cookies.jsp" %> 

<%
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String value 		= request.getParameter("value")==null?"":request.getParameter("value");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	String size		= request.getParameter("size")==null?"0":request.getParameter("size");
	String cons_dt		= request.getParameter("cons_dt")==null?"0":request.getParameter("cons_dt");
	
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_no		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	
	
	Vector vt = new Vector();
	if(value.equals("1")){
		vt = cons_db.getManSearch1("", s_kd, t_wd);
	}
	if(value.equals("4")){
		vt = cons_db.getManSearch4("", s_kd, t_wd, cons_dt);
	}
	if(value.equals("2") && !t_wd.equals("")){//고객
		vt = cons_db.getManSearch2("", s_kd, t_wd, rent_l_cd);
	}
	if(value.equals("3") && !t_wd.equals("")){
		vt = cons_db.getManSearch3("", s_kd, t_wd);
	}	
	int vt_size = vt.size();
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
	
	function send_apk(nm, m_tel){
		var fm = document.form1;
				
		if (confirm("차량번호 인식 URL 문자를 발송하시겠습니까?") ){	
			fm.action="send_apk_a.jsp?nm="+nm+ "&m_tel="+m_tel;		
			fm.target='i_no';
			fm.submit();
		}
	}	
	
	<%if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
	function Disp2(title, nm, tel, m_tel){
		var fm = document.form1;
		opener.form1.call_t_nm.value 	= nm;
		opener.form1.call_t_tel.value 	= m_tel;	
		if(m_tel == '' && tel !=''){
			opener.form1.call_t_tel.value 	= tel;	
		} 
		self.close();
	}			
	<%}else{%>	
	function Disp1(user_pos, user_id, user_nm, user_h_tel, user_m_tel){
		var fm = document.form1;
		if('<%=go_url%>' == '/fms2/consignment_new/cons_reg_step3.jsp' && '<%=size%>' == '1'){
			if(fm.value.value == '1'){
				opener.form1.<%=st%>_tel.value 		= user_h_tel;
				opener.form1.<%=st%>_title.value 	= user_pos;
				opener.form1.<%=st%>_man.value 		= user_nm;
				opener.form1.<%=st%>_m_tel.value 	= user_m_tel;		
			}else{
				opener.form1.<%=st%>_id.value 		= user_id;
				opener.form1.<%=st%>_nm.value 		= user_nm;
				opener.form1.<%=st%>_m_tel.value 	= user_m_tel;					
			}
		}else if('<%=go_url%>' == '/fms2/consignment_new/cons_reg_step2.jsp' && '<%=size%>' == '1'){
			if(fm.value.value == '1'){
				opener.form1.<%=st%>_tel.value 		= user_h_tel;
				opener.form1.<%=st%>_title.value 	= user_pos;
				opener.form1.<%=st%>_man.value 		= user_nm;
				opener.form1.<%=st%>_m_tel.value 	= user_m_tel;		
			}else{
				opener.form1.<%=st%>_id.value 		= user_id;
				opener.form1.<%=st%>_nm.value 		= user_nm;
				opener.form1.<%=st%>_m_tel.value 	= user_m_tel;					
			}
		}else{
			if(fm.value.value == '1'){
				opener.form1.<%=st%>_tel[<%=idx%>].value 	= user_h_tel;
				opener.form1.<%=st%>_title[<%=idx%>].value 	= user_pos;
				opener.form1.<%=st%>_man[<%=idx%>].value 	= user_nm;
				opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= user_m_tel;		
			}else{
				opener.form1.<%=st%>_id[<%=idx%>].value 	= user_id;
				opener.form1.<%=st%>_nm[<%=idx%>].value 	= user_nm;
				opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= user_m_tel;					
			}
		}
		self.close();
	}

	function Disp2(title, nm, tel, m_tel){
		var fm = document.form1;
		opener.form1.<%=st%>_tel[<%=idx%>].value 	= tel;
		opener.form1.<%=st%>_title[<%=idx%>].value 	= title;
		opener.form1.<%=st%>_man[<%=idx%>].value 	= nm;
		opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= m_tel;		
		self.close();
	}		
	
	function Disp3(nm, m_tel){
		var fm = document.form1;
		opener.form1.driver_nm[<%=idx%>].value 		= nm;
		opener.form1.driver_m_tel[<%=idx%>].value 	= m_tel;
		self.close();
	}			
	<%}%>	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_man.jsp'>
  <input type='hidden' name='st' value='<%=st%>'>    
  <input type='hidden' name='value' value='<%=value%>'>      
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type='hidden' name='go_url' value='<%=go_url%>'> 
  <input type='hidden' name='size' value='<%=size%>'>   
  <input type='hidden' name='cons_dt' value='<%=cons_dt%>'>     
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>     
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>     
  <input type='hidden' name='car_no' value='<%=car_no%>'>     
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <%if(value.equals("1")){//아마존카%>
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
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;		
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>성명</option>		  
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    <!--<input type="button" name="b_ms2" value="검색" onClick="javascript:search();" class="btn">-->
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
                    <td class=title width="15%">지점</td>
                    <td class=title width="15%">부서</td>			
                    <td class=title width="15%">직위</td>						
                    <td class=title width="15%">성명</td>
                    <td class=title width="15%">연락처</td>			
                    <td class=title width="15%">핸드폰</td>			
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("BR_NM")%></td>
                    <td><%=ht.get("NM")%></td>
                    <td><%=ht.get("USER_POS")%></td>		  		  
                    <td><a href="javascript:Disp1('<%=ht.get("USER_POS")%>', '<%=ht.get("USER_ID")%>', '<%=ht.get("USER_NM")%>', '<%=ht.get("USER_H_TEL")%>', '<%=ht.get("USER_M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM")%></a></td>
                    <td><%=ht.get("USER_H_TEL")%></td>		  		  
                    <td><%=ht.get("USER_M_TEL")%></td>		  		  		  
                </tr>
            <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
    <%if(value.equals("4")){%>
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
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" border="0" align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>성명</option>		  
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    <a href="javascript:search();" class="btn"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">연번</td>			
                    <td class=title width="15%">지점</td>
                    <td class=title width="15%">부서</td>			
                    <td class=title width="15%">직위</td>						
                    <td class=title width="15%">성명</td>
                    <td class=title width="15%">핸드폰</td>			
                    <td class=title width="15%">지원여부</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("BR_NM")%></td>
                    <td><%=ht.get("NM")%></td>
                    <td><%=ht.get("USER_POS")%></td>		  		  
                    <td><a href="javascript:Disp1('<%=ht.get("USER_POS")%>', '<%=ht.get("USER_ID")%>', '<%=ht.get("USER_NM")%>', '<%=ht.get("USER_H_TEL")%>', '<%=ht.get("USER_M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM")%></a></td>
                    <td><%=ht.get("USER_M_TEL")%></td>		  		  		  
                    <td><%=ht.get("STANDBY_ST")%></td>		  		  		  
                </tr>
            <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>	
	<%if(value.equals("2")){//고객
		//법인고객차량관리자
		Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
		int mgr_size = car_mgrs.size();	
	%>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 계약번호 : <%=rent_l_cd%> <%=car_no%> 고객관계자</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">연번</td>
                    <td class=title width="15%">구분</td>
                    <td class=title width="20%">부서/직위</td>
                    <td class=title width="15%">성명</td>		  
                    <td class=title width="20%">연락처</td>
                    <td class=title width="20%">핸드폰</td>
                </tr>
                <%for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=mgr.getMgr_st()%></td>
                    <td><%=mgr.getMgr_dept()%> <%=mgr.getMgr_title()%></td>		  
                    <td><a href="javascript:Disp2('<%=mgr.getMgr_title()%>', '<%=mgr.getMgr_nm()%>', '<%=mgr.getMgr_tel()%>', '<%=mgr.getMgr_m_tel()%>')" onMouseOver="window.status=''; return true"><%=mgr.getMgr_nm()%></a></td>
                    <td><%=mgr.getMgr_tel()%></td>
                    <td><%=mgr.getMgr_m_tel()%></td>
                </tr>
                <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    		
    <tr> 
        <td> <img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;		
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
	      <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>계약번호</option>
	      <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    &nbsp;<input type="button" name="b_ms2" value="검색" onClick="javascript:search();" class="btn">		    
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">연번</td>
                    <td class=title width="15%">구분</td>
                    <td class=title width="20%">부서/직위</td>
                    <td class=title width="15%">성명</td>		  
                    <td class=title width="20%">연락처</td>
                    <td class=title width="20%">핸드폰</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("GUBUN")%><%if(!String.valueOf(ht.get("CAR_NO")).equals("")){%><BR><%=ht.get("CAR_NO")%><%}%></td>
                    <td><%=ht.get("TITLE")%></td>		  
                    <td><a href="javascript:Disp2('<%=ht.get("TITLE")%>', '<%=ht.get("NM")%>', '<%=ht.get("TEL")%>', '<%=ht.get("M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
                    <td><%=ht.get("TEL")%></td>
                    <td><%=ht.get("M_TEL")%></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<%if(value.equals("3")){//협력업체%>	
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;		 
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=whitetext onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    <!--<input type="button" name="b_ms2" value="검색" onClick="javascript:search();" class="btn">-->
        </td>
    </tr>
    
   	<%if( !t_wd.equals("")){%>
    <tr> 
        <td>※ 최근 1달 동안 탁송배정된 운전자 리스트입니다.</td>
    </tr>
    <tr> 
        <td>※ 차량번호인식은 아이폰은 지원하지 않으며, 당분간 아마존탁송만 사용합니다.</td>
    </tr>
	<%}%>
	     
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    
    	
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">연번</td>
                    <td class=title width="40%">운전자명</td>
                    <td class=title width="50%">핸드폰번호</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				String m_tel = (String)ht.get("M_TEL");
    				String name = (String)ht.get("NM");
    				
    				if(!m_tel.contains("01035580026")  &&  !m_tel.contains("01090905323") &&  !m_tel.contains("01040140911")  && !m_tel.contains("01043747353") && !name.contains("이영진")){		//맹영철(휴대폰번호 바뀜)(2017.09.25) , 정만복, 정형석, 유명훈 추가     		   					
    																																													// 2020.11.17.정형석 기사님 목록에 노출. !m_tel.contains("01049451922") 조건에서 제외. 
    			%>
	                <tr align="center">
	                    <td><%=i+1%></td>
	                    <td><a href="javascript:Disp3('<%=ht.get("NM")%>', '<%=ht.get("M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
	                    <td><%=ht.get("M_TEL")%>
	                      &nbsp;&nbsp;
	                    <a href="javascript:send_apk('<%=ht.get("NM")%>', '<%=ht.get("M_TEL")%>')" onMouseOver="window.status=''; return true">차량번호인식</a> <!-- 안드로이드에 한해서 -->
	                    	     
	                    </td>
	                </tr>
                <%		
                	}
                }%>
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