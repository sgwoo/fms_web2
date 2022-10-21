<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//차량임시회수리스트
	Vector vt = a_db.getCarCallInList(m_id, l_cd);
	int vt_size = vt.size();
	
	//차량회수여부
	int in_size 			= af_db.getYnCarCallIn(m_id, l_cd);

%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_callin(seq){
	 	var fm = document.form1;
		fm.seq.value = seq;
		fm.action = 'car_call_in.jsp';
		fm.target = 'callreg';		
		fm.submit();
  	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body>

<form action='' method="post" name='form1'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='seq' value='<%=seq%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > <span class=style5>
						차량회수관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
	<tr><td class=line2></td></tr>
    <tr>
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>		    	
                <tr>
                    <td width='15%' class='title'>계약번호</td>
                    <td width='20%'>&nbsp;
        			        <%=base.get("RENT_L_CD")%></td>
                    <td width='15%' class='title'>상호</td>
                    <td width="50%">&nbsp;
        			        <%=base.get("FIRM_NM")%></td>
                </tr>
		      <%if(!String.valueOf(base.get("R_SITE")).equals("")){%>
                <tr>
                    <td class='title'>사용본거지</td>
                    <td colspan="3">&nbsp; <%=base.get("R_SITE")%></td>
                </tr>	
		      <%}%>	   
                <tr>
                    <td class='title'>차량번호</td>
                    <td>&nbsp;
        			        <font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;
			        <span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr>
                    <td class='title'> 대여방식 </td>
                    <td>&nbsp;
        			        <%=base.get("RENT_WAY")%></td>
                    <td class='title'>CMS</td>
                    <td>&nbsp;
        				      <%if(!cms.getCms_bank().equals("")){%>
							  <b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
        			 	      <%=cms.getCms_bank()%>:<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>(매월<%=cms.getCms_day()%>일)
        			 	      <%}else{%>
        			      	-
        			 	      <%}%>
        	        </td>
                </tr>
                <tr>
                    <td class='title'>영업담당자</td>
                    <td>&nbsp;
        			        <%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td class='title'>관리담당자</td>
                    <td>&nbsp;
        			        <%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>		   
            </table>
	    </td>
    </tr>
    <tr>
	    <td align='right'>&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr>		
    <tr>
	    <td align='right' class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="6%" class='title'>연번</td>
                    <td width="10%" class='title'>구분</td>
                    <td width="15%" class='title'>회수일자</td>
                    <td width="29%" class='title'>사유</td>
                    <td width="15%" class='title'>인도/해지일자</td>					
                    <td width="15%" class='title'>등록일</td>
                    <td width="10%" class='title'>등록자</td>
                </tr>
<%		    for(int i = 0 ; i < vt_size ; i++){
			      Hashtable ht = (Hashtable)vt.elementAt(i);%>		  		
                 <tr align="center">
                    <td><%=i+1%></td>
                    <td><%if(String.valueOf(ht.get("IN_ST")).equals("1")){%>연체
					    <%}else if(String.valueOf(ht.get("IN_ST")).equals("2")){%>고객요청
						<%}else if(String.valueOf(ht.get("IN_ST")).equals("3")){%>해지반납
						<%}else if(String.valueOf(ht.get("IN_ST")).equals("4")){%>해지전 보험관리
						<%}%></td>
                    <td>
					<%if(nm_db.getWorkAuthUser("본사관리팀장",ck_acar_id) || nm_db.getWorkAuthUser("보유차관리자들",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
					<a href="javascript:view_callin('<%=ht.get("SEQ")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("IN_DT")))%></a>
					<%}else{%>
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("IN_DT")))%>
					<%}%>
					</td>
                    <td><%=ht.get("IN_CAU")%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("OUT_DT")))%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%></td>					
                </tr>
<%		    }%>		
<%		    if(vt_size==0){%>		
		        <tr>
	  	            <td colspan='9' align="center">등록된 데이타가 없습니다.</td>
    	        </tr>		
<%		    }%>		
            </table>
        </td>
    </tr>	
    <tr>
	    <td></td>
    </tr>
	<%if(nm_db.getWorkAuthUser("본사관리팀장",ck_acar_id) || nm_db.getWorkAuthUser("보유차관리자들",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량회수 등록</span></td>
    </tr>
    <tr>
	    <td valign=top><iframe src="car_call_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&seq=<%=seq%>" name="callreg" width="100%" height="310" cellpadding="0" cellspacing="0" border="0" frameborder="0" topmargin=0 noresize></iframe></td>
    </tr>		
	<%}else{%>
	<%		if(in_size==0){%>


    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량회수 등록</span></td>
    </tr>
    <tr>
	    <td valign=top><iframe src="car_call_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&seq=<%=seq%>" name="callreg" width="100%" height="310" cellpadding="0" cellspacing="0" border="0" frameborder="0" topmargin=0 noresize></iframe></td>
    </tr>		
	<%		}else{%>	
    <tr>
	    <td>* 완료처리 되지 않은 회수가 있습니다. 완료처리후 등록할 수 있습니다.</td>
    </tr>	
	<%		}%>
	<%}%>
</table>
</form>
</body>
</html>
