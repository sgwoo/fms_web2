<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.inside_bank.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = d_db.getFeeScdDocList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
	
	IbBulkTranResultBean ibt = new IbBulkTranResultBean();
%>

<html>
<head><title>FMS</title>
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
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='1330'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='400' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='30' class='title' style='height:45'>연번</td>
		    <td width='50' class='title'>&nbsp;<br>구분<br>&nbsp;</td>
		    <td width='100' class='title'>계약번호</td>
		    <td width="130" class='title'>고객</td>
        	    <td width='90' class='title'>차량번호</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='930'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='150' rowspan="2" class='title'>차명</td>
		    <td colspan="3" class='title'>결재</td>	
		    <td colspan="3" class='title'>대여료</td>
		    <td width='120' rowspan="2" class='title'>구분</td>				
		    <td colspan="2" class='title'>1회차납입일</td>
		</tr>
		<tr>
		    <td width='80' class='title'>기안일자</td>				
		    <td width='70' class='title'>기안자</td>
		    <td width='140' class='title'>스케줄담당</td>
		    <!--<td width='70' class='title'>총무팀장</td>-->			          
		    <td width='70' class='title'>월대여료</td>
		    <td width='70' class='title'>DC금액</td>
		    <td width='70' class='title'>납입월수</td>			          
		    <td width='80' class='title'>변경전</td>				  		  				  
		    <td width='80' class='title'>변경후</td>			  
		</tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>
	<td class='line' width='400' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr>
		    <td  width='30' align='center'><%=i+1%></td>
		    <td  width='50' align='center'><%=ht.get("BIT")%></td>
		    <td  width='100' align='center'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
		    <td  width='130'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
		    <td  width='90' align='center'><%=ht.get("CAR_NO")%></td>
		</tr>
                <%}%>
	    </table>
	</td>
	<td class='line' width='930'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		<tr>
		    <td width='150'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 17)%></span></td>				
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>					
		    <td  width='70' align='center'>
			<!--기안자-->
			<a href="javascript:parent.doc_action('1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM1")%></a>
		    </td>
		    <td  width='140' align='center'>
			<!--(스케줄변경)회계담당자-->			
		        <%if(String.valueOf(ht.get("USER_DT2")).equals("")){%>		        
			<%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id) ){%>			
			<font color='#CCCCCC'><%=ht.get("USER_NM2")%>&nbsp;
			<a href="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
			<%	}else{%>-<%}%>
			<%}else{%>
			<a href="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM2")%></a>
			<%}%>
		    </td>
		    <!--														 
		    <td  width='70' align='center'>-->
			<!--관리팀장-->
			<!--
			<%if(String.valueOf(ht.get("USER_DT3")).equals("")){%>
			<%    	if(!String.valueOf(ht.get("USER_ID3")).equals("XXXXXX")){%>
			<%		if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("계약결재",user_id) || nm_db.getWorkAuthUser("지점장",user_id) ){%>
			<a href="javascript:parent.doc_action('3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
			<%		}else{%>-<%}%>
			<%	}else{%>-<%}%>
			<%}else{%>
			<a href="javascript:parent.doc_action('3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM3")%></a>
			<%}%>
		    </td>		
		    -->
		    <td  width='70' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>					
		    <td  width='70' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CHA_AMT")))%></td>
		    <td  width='70' align='center'><%=ht.get("FEE_PAY_TM")%></td>					
		    <td  width='120' align='center'><%=ht.get("REG_TYPE")%></td>					
		    <td  width='80' align='center'><%=ht.get("VAR05")%><%if(String.valueOf(ht.get("VAR05")).equals("")){%><%=ht.get("VAR12")%><%}%></td>					
		    <td  width='80' align='center'><%=ht.get("VAR19")%></td>
		</tr>
                <%}%>
	    </table>
	</td>
        <%}else{%>                     
    <tr>
	<td class='line' width='400' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
			<%if(t_wd.equals("")){%>검색어를 입력하십시오.
			<%}else{%>등록된 데이타가 없습니다<%}%></td>
		</tr>
	    </table>
	</td>
	<td class='line' width='930'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
