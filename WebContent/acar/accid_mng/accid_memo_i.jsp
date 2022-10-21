<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.cont.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
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
	String seq_no = request.getParameter("seq_no")==null?"1":request.getParameter("seq_no");//사고관리일련번호
	String mode = request.getParameter("mode")==null?"11":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String tm_st = request.getParameter("tm_st")==null?"6":request.getParameter("tm_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddClientDatabase al_db = AddClientDatabase.getInstance();
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getClient(String.valueOf(cont.get("CLIENT_ID")));
	
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	//보험청구내역(휴차/대차료)
	MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(!car_st.equals(""))	car_st = car_st.substring(4,5);
	
	String accid_dt = a_bean.getAccid_dt();
	String accid_dt_h = "";
	String accid_dt_m = "";
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);
		accid_dt_h = a_bean.getAccid_dt().substring(8,10);
		accid_dt_m = a_bean.getAccid_dt().substring(10,12);
	}	
	
	//상대차량 인적사항
	OtAccidBean oa_r [] = as_db.getOtAccid(c_id, accid_id);	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;
		if(fm.speaker.value == '')			{	alert('통화자를 확인하십시오');	return;	}
		else if(fm.content.value == '')		{	alert('메모내용을 확인하십시오');	return;	}		
		if(confirm('등록하시겠습니까?')){		
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>사고통화내역</span></span></td>
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
                    <td class=title width=13%>상호</td>
                    <td width=37%>&nbsp;<%=cont.get("FIRM_NM")%></td>
                    <td class=title width=13%>차량번호</td>
                    <td width=37%>&nbsp;<%=cont.get("CAR_NO")%></td>
                </tr>
                <tr> 
                    <td class=title>사고구분</td>
                    <td>
                    <%if(a_bean.getAccid_st().equals("1")){%>
                    &nbsp;피해자 
                    <%}%>
                    <%if(a_bean.getAccid_st().equals("2")){%>
                    &nbsp;가해자 
                    <%}%>
                    <%if(a_bean.getAccid_st().equals("3")){%>
                    &nbsp;쌍방 
                    <%}%>
                    <%if(a_bean.getAccid_st().equals("5")){%>
                    &nbsp;단독 
                    <%}%>
                    <%if(a_bean.getAccid_st().equals("4")){%>
                    &nbsp;운행자차 
                    <%}%>
                    </td>
                    <td class=title>사고일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(accid_dt)%> <%=accid_dt_h%>시 <%=accid_dt_h%>분</td>
                </tr>
                <tr> 
                    <td class=title>사무실</td>
                    <td>&nbsp;<%= client.getO_tel()%></td>
                    <td class=title>팩스</td>
                    <td>&nbsp;<%= client.getFax()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr> 
        <td class=line> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class=line width="50%"> 
                        <table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td class=title colspan="2" width=25%>구분</td>
                                <td class=title width=25%>이름</td>
                                <td class=title width=25%>전화번호</td>
                                <td class=title width=25%>휴대폰</td>
                            </tr>
                      <%
                      	Vector car_mgrs = a_db.getCarMgr(m_id, l_cd);
                      	for(int i = 0 ; i < 3 ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
                            <tr> 
                        <%if(i==0){%>
                                <td align="center" rowspan="4" width=6%><font color="#999900">거래처</font></td>
                                <%}%>
                                <td align="center"><%= mgr.getMgr_st()%></td>
                                <td align="center"><%= mgr.getMgr_nm()%></td>
                                <td align="center"><%= mgr.getMgr_tel()%></td>
                                <td align="center"><%= mgr.getMgr_m_tel()%></td>
                            </tr>
                      <%}%>
                            <tr> 
                                <td align="center">운전자</td>
                                <td align="center"><%=a_bean.getOur_driver()%></td>
                                <td align="center"><%=a_bean.getOur_tel()%></td>
                                <td align="center"><%=a_bean.getOur_m_tel()%></td>
                            </tr>
                        </table>
                    </td>
                    <td class=line width="50%"> 
                        <table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td class=title colspan="2" width=25%>구분</td>
                                <td class=title width=25%>이름</td>
                                <td class=title width=25%>전화번호</td>
                                <td class=title width=25%>휴대폰</td>
                            </tr>
                            <tr> 
                                <td align="center" rowspan="3" width=6%><font color="#999900">보험사</font></td>
                                <td align="center">대인</td>
                                <td align="center"><%=a_bean.getOne_nm()%></td>
                                <td align="center"><%=a_bean.getOne_tel()%></td>
                                <td align="center">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td align="center">대물</td>
                                <td align="center"><%=a_bean.getMy_nm()%></td>
                                <td align="center"><%=a_bean.getMy_tel()%></td>
                                <td align="center">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td align="center"> 
                                  <%if(car_st.equals("허")){%>
                                  휴차료 
                                  <%}else{%>
                                  대차료 
                                  <%}%>
                                </td>
                                <td align="center"><%=ma_bean.getIns_nm()%></td>
                                <td align="center"><%=ma_bean.getIns_tel()%></td>
                                <td align="center"><%=ma_bean.getIns_tel2()%></td>
                            </tr>
                            <tr> 
                                <td align="center" colspan="2" height="2"><font color="#999900"><%=a_bean.getOt_pol_sta()%>
                                  <%if(a_bean.getOt_pol_sta().equals("")){%>
                                  경찰서
                                  <%}%>
                                  </font></td>
                                <td align="center" height="2"><%=a_bean.getOt_pol_nm()%></td>
                                <td align="center" height="2"><%=a_bean.getOt_pol_tel()%></td>
                                <td align="center" height="2"><font size="1">(fax)</font><%=a_bean.getOt_pol_fax()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
<%if(oa_r.length > 0){%>			  
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
        <%for(int i=0; i<oa_r.length; i++){
    			oa_bean = oa_r[i];%>
                <tr> 
                    <td align="center" width=7%><font color="#999900">상대<%=i+1%></font></td>
                    <td width=31%>&nbsp;<font color="#009900">운전자</font> (<%=oa_bean.getOt_driver()%>, 
                    <%=oa_bean.getOt_tel()%>, <%=oa_bean.getOt_m_tel()%>)</td>
                    <td width=31%>&nbsp;<font color="#009900">대인담당자</font> (<%=oa_bean.getHum_nm()%>, 
                    <%=oa_bean.getHum_tel()%>)</td>
                    <td width=31%>&nbsp;<font color="#009900">대물담당자</font> (<%=oa_bean.getMat_nm()%>, 
                    <%=oa_bean.getMat_tel()%>)</td>
                </tr>
        <%}%>
            </table>
        </td>
    </tr>
<%}%>  
    <tr>
        <td></td>
    </tr>
  <form action="accid_memo_i_a.jsp" name="form1" method="POST">
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
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='seq' value='<%=seq%>'>
    <input type='hidden' name='tm_st' value='<%=tm_st%>'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=13%> 작성일 </td>
                    <td colspan='3' width=87%>&nbsp; <input type='text' name='reg_dt' value='<%=Util.getDate()%>' size='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'> 작성자</td>
                    <td colspan='3'>&nbsp; <%=c_db.getNameById(user_id, "USER")%></td>
                </tr>
                <tr> 
                    <td class='title'> 통화자</td>
                    <td colspan='3'>&nbsp; <input type='text' name='speaker' size='20' class='text'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'> 내용</td>
                    <td colspan='3'>&nbsp; <textarea name='content' rows='4' cols='100'></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
  </form>
    <tr> 
        <td align="right"> 
          <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp; 
          <a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
        </td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>