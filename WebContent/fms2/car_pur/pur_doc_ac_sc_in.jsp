<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
			
	Vector vt = d_db.getCarPurAcDocList(s_kd, t_wd, gubun1, gubun2);
	int vt_size = vt.size();
	
	int count =0;
	
	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)){
		mng_mode = "A";
	}	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_ts.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}			
//-->
</script>

<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_ac_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='1170'>
    <tr>
      <td colspan="2" class=line2></td>
    </tr>  
	  <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='510' id='td_title' style='position:relative;'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		      <tr>
			      <td width='40' class='title' style='height:45'>연번</td>
			      <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
			      <td width='60' class='title'>&nbsp;<br>구분<br>&nbsp;</td>
		        <td width='100' class='title'>계약번호</td>
        		<td width='80' class='title'>계약일</td>
		        <td width="100" class='title'>차명</td>
		        <td width="100" class='title'>전차량번호</td>
		      </tr>
		    </table>
	    </td>
	    <td class='line' width='660'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		      <tr>
			      <td colspan="3" class='title'>결재</td>					
			      <td colspan="3" class='title'>중고차</td>
			      <td width='80' rowspan="2" class='title'>차량대금<br>지급일자</td>
		      </tr>
		      <tr>
			      <td width='60' class='title'>기안자</td>
			      <td width='60' class='title'>출고관리</td>
			      <td width='60' class='title'>팀장</td>
			      <td width='100' class='title'>제조사</td>
			      <td width='150' class='title'>판매처</td>
			      <td width='150' class='title'>딜러</td>
		      </tr>
		    </table>
	    </td>
	  </tr>
    <%if(vt_size > 0){%>
	  <tr>
	    <td class='line' width='510' id='td_con' style='position:relative;'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("RENT_L_CD")).equals("K316KYPR00089")) continue;
							count++;
          %>
		      <tr>
		        <td  width='40' align='center'><%=count%></td>
		        <td  width='30' align='center'><%if(!String.valueOf(ht.get("DOC_STEP")).equals("") && String.valueOf(ht.get("PUR_PAY_DT")).equals("")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("CAR_EST_AMT")%>/<%=ht.get("CON_EST_DT")%>" onclick="javascript:parent.select_purs_amt();"><%}else{%>-<%}%></td>
		        <td  width='60' align='center'><%=ht.get("BIT")%></td>
		        <td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
		        <td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
		        <td  width='100'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 7)%></span></td>
		        <td  width='100' align='center'><%=ht.get("EST_CAR_NO")%></td>
		      </tr>
          <%}%>
		    </table>
	    </td>
	    <td class='line' width='660'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("RENT_L_CD")).equals("K316KYPR00089")) continue;
							int chk_cnt = 0;
					%>
		      <tr>
			      <td  width='60' align='center'>
			        <!--기안자-->
			        <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>			  
			        <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a>			  
			        <%}else{%>
			        <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
			        <%}%>
			      </td>
			      <td  width='60' align='center'>
			        <!--출고담당자-->
			        <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT3")).equals("")){%>
			        <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || mng_mode.equals("A")){%>
			        <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
			        <%	}else{%>-<%}%>
			        <%}else{%>
			        <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%></a>
			        <%}%>
			      </td>
			      <td  width='60' align='center'>
			        <!--총무팀장-->
			        <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT5")).equals("")){%>
			        <%	if(String.valueOf(ht.get("USER_ID5")).equals(user_id) || mng_mode.equals("A")){%>
			        <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '5', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
			        <%	}else{%>-<%}%>
			        <%}else{%>
			        <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '5', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID5")),"USER")%></a>
			        <%}%>
			      </td>
			      <td width='100' align='center'><span title='<%=ht.get("CAR_COMP_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_COMP_NM")), 8)%></span></td>
			      <td width='150' align='center'><span title='<%=ht.get("CAR_OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_OFF_NM")), 10)%></span></td>
			      <td width='150' align='center'><span title='<%=ht.get("DEALER_NM")%>'><%=Util.subData(String.valueOf(ht.get("DEALER_NM")), 10)%></span></td>
			      <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%>
		      </tr>
          <%}%>
		    </table>
	    </td>
	  </tr>    
    <%}else{%>                     
	  <tr>
	    <td class='line' width='510' id='td_con' style='position:relative;'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		      <tr>
			      <td align='center'>
			        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
			        <%}else{%>등록된 데이타가 없습니다<%}%>
			      </td>
		      </tr>
		    </table>
	    </td>
	    <td class='line' width='660'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		      <tr>
			      <td>&nbsp;</td>
		      </tr>
		    </table>
	    </td>
	  </tr>
    <%}%>
  </table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
