<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.cont.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = ec_db.getLcStartStat4List(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
	
	String cont_cng_id = nm_db.getWorkAuthUser("연장/승계담당자");
	//사용자 정보 조회
	UsersBean cont_cng_id_bean = umd.getUsersBean(cont_cng_id);
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
<body>
<table border="0" cellspacing="0" cellpadding="0" width='1210'>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
		<td class=line>
	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		    		<td width='50' class='title'>연번</td>
		    		<td width='50' class='title'>구분</td>
				    <td width='100' class='title'>계약번호</td>
				    <td width="200" class='title'>고객</td>
        		    <td width='100' class='title'>차량번호</td>
				    <td width='150' class='title'>차명</td>				
				    <td width='80' class='title'>계약일자</td>
		    		<td width='80' class='title'>대여개시일</td>
		    		<td width='80' class='title'>대여만료일</td>			          
		    		<td width='80' class='title'>최종사용일</td>
		    		<td width='80' class='title'>최초영업자</td>
		    		<td width='80' class='title'>개시기안자</td>
		    		<td width='80' class='title'>스케줄담당</td>
				</tr>
    			<%if(vt_size > 0){%>
                <%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);		
						String red_yn = ht.get("RED_YN")+"";
						//다중 출고전대차인 경우 전체기간으로 비교해도 나오는지 다시 본다.
						if(String.valueOf(ht.get("GUBUN")).equals("지연") && red_yn.equals("Y")){
							Hashtable tc = ec_db.getTaechaScdDayAllChk(String.valueOf(ht.get("RENT_L_CD")));
							red_yn = tc.get("RED_YN")+"";
							if(red_yn.equals("N")) continue;
						}
						count++;
				%>			
				<tr>
		    		<td width='50' align='center'><%=count%></td>
		    		<td width='50' align='center'><%=ht.get("GUBUN")%></td>
		    		<td width='100' align='center'><a href="javascript:parent.view_scd_fee('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_ST")%>','미등록', '<%=ht.get("GUBUN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
		    		<td width='200'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 15)%></span></td>
		    		<td width='100' align='center'><%=ht.get("CAR_NO")%></td>
				    <td width='150'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 17)%></span></td>				
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
				    <td width='80' align='center'><%if(red_yn.equals("Y")){%><font color=red><%}%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%><%if(red_yn.equals("Y")){%></font><%}%></td>
				    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
				    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
				    <td width='80' align='center'><%=ht.get("USER_NM")%></td>
				    <td width='80' align='center'><%if(!String.valueOf(ht.get("GUBUN")).equals("연장")){%><%=ht.get("DOC_USER_NM1")%><%}else{%><%=ht.get("USER_NM")%><%}%></td>
				    <td width='80' align='center'><%if(!String.valueOf(ht.get("GUBUN")).equals("연장")){%><%=ht.get("DOC_USER_NM2")%><%}else{%><%=cont_cng_id_bean.getUser_nm()%><%}%></td>
				</tr>
                <%	}%>
        		<%}else{%>                     
				<tr>
				    <td align='center'>
						<%if(t_wd.equals("")){%>검색어를 입력하십시오.
						<%}else{%>등록된 데이타가 없습니다<%}%>
					</td>
				</tr>
				<%}%>
			</table>	
		</td>
	</tr>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=count%>';
//-->
</script>
</body>
</html>
